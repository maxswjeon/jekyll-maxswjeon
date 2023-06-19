document
  .getElementById("sidebar-toggle")
  .addEventListener("click", function () {
    if (document.body.hasAttribute("data-sidebar-open")) {
      document.body.removeAttribute("data-sidebar-open");
    } else {
      document.body.setAttribute("data-sidebar-open", "");
    }
  });
