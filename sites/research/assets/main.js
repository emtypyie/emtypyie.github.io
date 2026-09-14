(function () {
  var htmlEl = document.documentElement;

  var saved = null;
  try { saved = localStorage.getItem("research-theme"); } catch (e) {}
  if (saved) htmlEl.setAttribute("data-theme", saved);

  var page = document.body.dataset.page || "";
  document.querySelectorAll("#mainnav a[data-route]").forEach(function (a) {
    a.classList.toggle("active", a.dataset.route === page);
  });

  var year = document.getElementById("copyright-year");
  if (year) year.textContent = new Date().getFullYear();

  var btn = document.getElementById("themeToggle");
  var icon = document.getElementById("themeIcon");
  if (btn && icon) {
    var MOON = '<circle cx="12" cy="12" r="5"/><path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"/>';
    var SUN  = '<path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>';
    function apply(mode) {
      htmlEl.setAttribute("data-theme", mode);
      try { localStorage.setItem("research-theme", mode); } catch (e) {}
      icon.innerHTML = mode === "dark" ? MOON : SUN;
      icon.setAttribute("fill", mode === "dark" ? "currentColor" : "none");
    }
    apply(htmlEl.getAttribute("data-theme") || "dark");
    btn.addEventListener("click", function () {
      apply(htmlEl.getAttribute("data-theme") === "dark" ? "light" : "dark");
    });
  }
})();