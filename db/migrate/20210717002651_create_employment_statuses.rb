class CreateEmploymentStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :employment_statuses do |t|
      t.integer :profile_id
      t.boolean :full_time_employed
      t.boolean :part_time_casual
      t.boolean :full_time_student
      t.boolean :part_time_student
      t.boolean :not_employed_looking
      t.boolean :not_employed_not_looking
      t.boolean :retired
      t.boolean :not_able_to_work
      t.boolean :prefer_not_to_say
      t.timestamps
    end

    profile_full_time_employed_count = Profile.where(employment: 0).count
    profile_part_time_casual_count = Profile.where(employment: 1).count
    profile_full_time_student_count = Profile.where(employment: 2).count
    profile_part_time_student_count = Profile.where(employment: 3).count
    profile_not_employed_looking_count = Profile.where(employment: 4).count
    profile_not_employed_not_looking_count = Profile.where(employment: 5).count
    profile_retired_count = Profile.where(employment: 6).count
    profile_not_able_to_work_count = Profile.where(employment: 7).count
    profile_prefer_not_to_say_count = Profile.where(employment: 8).count

    attributes = {
      0 => :full_time_employed,
      1 => :part_time_casual,
      2 => :full_time_student,
      3 => :part_time_student,
      4 => :not_employed_looking,
      5 => :not_employed_not_looking,
      6 => :retired,
      7 => :not_able_to_work,
      8 => :prefer_not_to_say,
    }

    Profile.all.where.not(employment: nil).each do |profile|
      EmploymentStatus.create profile: profile, attributes[Profile.employments[profile.employment]] => true
    end

    raise if profile_full_time_employed_count != EmploymentStatus.where(full_time_employed: true).count
    raise if profile_part_time_casual_count != EmploymentStatus.where(part_time_casual: true).count
    raise if profile_full_time_student_count != EmploymentStatus.where(full_time_student: true).count
    raise if profile_part_time_student_count != EmploymentStatus.where(part_time_student: true).count
    raise if profile_not_employed_looking_count != EmploymentStatus.where(not_employed_looking: true).count
    raise if profile_not_employed_not_looking_count != EmploymentStatus.where(not_employed_not_looking: true).count
    raise if profile_retired_count != EmploymentStatus.where(retired: true).count
    raise if profile_not_able_to_work_count != EmploymentStatus.where(not_able_to_work: true).count
    raise if profile_prefer_not_to_say_count != EmploymentStatus.where(prefer_not_to_say: true).count

    remove_column :profiles, :employment, :integer
  end
end
