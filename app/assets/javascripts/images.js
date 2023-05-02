
// check if we are on the sign up / sign in page 
if (window.location.href.endsWith("users/sign_in") || window.location.href.endsWith("/users/sign_up")){
    // list of images 
    const imagesOverlays = [
        ,"https://govhack.org/wp-content/uploads/2022/06/road-trip-with-raj-J61Sh5YrQho-unsplash.jpg"
        ,"https://govhack.org/wp-content/uploads/2022/06/kishan-modi-UJR6GY2qtW4-unsplash.jpg"
        ,"https://govhack.org/wp-content/uploads/2022/06/davide-dalfovo-1rQs3661lq4-unsplash.jpg"
        ,"https://govhack.org/wp-content/uploads/2022/06/lode-lagrainge-oAYs_Jr1RnQ-unsplash.jpg"
        ,"https://govhack.org/wp-content/uploads/2022/06/dan-freeman-hIKVSVKH7No-unsplash.jpg"
        ,"https://govhack.org/wp-content/uploads/2022/06/tobias-keller-73F4pKoUkM0-unsplash.jpg"
        ,"https://govhack.org/wp-content/uploads/2022/06/trevor-mckinnon-XfjmDeR7P7E-unsplash-1.jpg"
        ,"https://govhack.org/wp-content/uploads/2022/06/spencer-chow-LdvSgcne6kM-unsplash-1.jpg"
        ,"https://govhack.org/wp-content/uploads/2022/06/tobias-keller-gF0IZVVKrD0-unsplash.jpg"
    ]
    // get a random image from a random index
    const randomImage = imagesOverlays[Math.floor(Math.random() * imagesOverlays.length)]
    // wait for entire dom to load before proceeding to change the background image url
    window.addEventListener("load", function(event) {
    const rhsImage = document.querySelector('.rhs-image');
    rhsImage.style.backgroundImage = `url(${randomImage})`
      });
}
