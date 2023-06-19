document
  .getElementById("sidebar-toggle")
  .addEventListener("click", function () {
    if (document.body.hasAttribute("data-sidebar-open")) {
      document.body.removeAttribute("data-sidebar-open");
    } else {
      document.body.setAttribute("data-sidebar-open", "");
    }
  });

const searchDialog = document.getElementById("search-dialog");
document.getElementById("search").addEventListener("click", function () {
  if (document.body.hasAttribute("data-search-open")) {
    document.body.removeAttribute("data-search-open");
  } else {
    document.body.setAttribute("data-search-open", "");
    searchDialog.querySelector("input").focus();
  }
});

searchDialog.addEventListener("click", function (e) {
  e.stopPropagation();
});

document
  .getElementById("search-dialog-background")
  .addEventListener("click", function () {
    document.body.removeAttribute("data-search-open");
  });
