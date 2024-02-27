document.addEventListener("turbo:load", function () {
  const account = document.querySelector("#account");
  account.addEventListener("click", function (event) {
    event.preventDefault();
    const menu = document.querySelector("#dropdown-menu");
    menu.classList.toggle("active");
  });
});
