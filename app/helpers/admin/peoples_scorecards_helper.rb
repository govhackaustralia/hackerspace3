module Admin::PeoplesScorecardsHelper
  def teams_by_peoples_scorecards
    TeamsByPeoplesScorecards.new(@competition).retrieve
  end

  class TeamsByPeoplesScorecards
    def initialize(competition)
      @scorecards = competition.peoples_scorecards
      @teams = competition.teams
      @judgements = competition.peoples_judgements
      @projects = competition.projects.order(created_at: :desc)
    end

    def retrieve
      organise_team_objects
      organise_score_objects
      set_teams_by_score_object
    end

    def organise_team_objects
      @team_id_to_card_scores = {}
      @team_id_to_team_name = {}
      @teams.each { |team| current_project_name(team) }
    end

    def current_project_name(team)
      set_team_objects
      @team_id_to_card_scores[team.id] = []
      project = if team.project_id.present?
                  @project_id_to_project[team.project_id]
                else
                  @team_id_to_projects[team.id].first
                end
      @team_id_to_team_name[team.id] = project.team_name
    end

    def organise_score_objects
      set_score_object
      @card_id_to_team_id = {}
      @scorecards.each { |sc| @card_id_to_team_id[sc.id] = sc.team_id }
      @card_id_to_score.each do |card_id, score|
        @team_id_to_card_scores[@card_id_to_team_id[card_id]] << score
      end
    end

    def set_teams_by_score_object
      @teams_by_score = []
      @team_id_to_card_scores.each do |team_id, card_scores|
        add_team_obj(team_id, card_scores)
      end
      @teams_by_score.sort_by! { |obj| obj[:average_score] }.reverse!
    end

    def add_team_obj(team_id, card_scores)
      new_obj = {}
      new_obj[:team_name] = @team_id_to_team_name[team_id]
      new_obj[:peoples_votes] = card_scores.length
      new_obj[:average_score] = if new_obj[:peoples_votes].zero?
                                  0
                                else
                                  card_scores.sum / new_obj[:peoples_votes]
                                end
      @teams_by_score << new_obj
    end

    def set_team_objects
      @team_id_to_projects = {}
      @project_id_to_project = {}
      @projects.each do |project|
        if @team_id_to_projects[project.team_id].nil?
          @team_id_to_projects[project.team_id] = []
        end
        @team_id_to_projects[project.team_id] << project
        @project_id_to_project[project.id] = project
      end
    end

    def set_score_object
      @card_id_to_score = {}
      @judgements.each do |judgement|
        next if judgement.score.nil?
        if @card_id_to_score[judgement.peoples_scorecard.id].nil?
          @card_id_to_score[judgement.peoples_scorecard.id] = 0
        end
        @card_id_to_score[judgement.peoples_scorecard_id] += judgement.score
      end
    end
  end
end
