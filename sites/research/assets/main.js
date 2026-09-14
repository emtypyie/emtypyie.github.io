(function () {
  var page = document.body.dataset.page || "";
  document.querySelectorAll("#mainnav a[data-route]").forEach(function (a) {
    a.classList.toggle("current", a.dataset.route === page);
  });
  var year = document.getElementById("copyright-year");
  if (year) year.textContent = new Date().getFullYear();
})();