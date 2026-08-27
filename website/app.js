// Sofintel landing page — install tabs, mobile nav, and dynamic year.
(function () {
  var GITHUB = "https://github.com/sofintel/sofintel";

  // Install command tabs.
  var installOptions = [
    { id: "curl", label: "curl", cmd: "curl -fsSL " + GITHUB + "/releases/latest/download/install.sh | sh" },
    { id: "brew", label: "brew", cmd: "brew install sofintel" },
    { id: "cargo", label: "cargo", cmd: "cargo install sofintel" },
    { id: "linux", label: "Linux", cmd: "sudo dpkg -i Sofintel-1.0.3-amd64.deb" },
    { id: "windows", label: "Windows", cmd: "irm " + GITHUB + "/releases/latest/download/sofintel.ps1 | iex" },
  ];

  function renderInstallTabs() {
    var mount = document.getElementById("install-tabs");
    if (!mount) return;

    var wrap = document.createElement("div");
    wrap.className = "install-tabs";

    var tabs = document.createElement("div");
    tabs.className = "tabs";

    var command = document.createElement("div");
    command.className = "command";

    var active = installOptions[0].id;
    var commandEl = document.createElement("code");
    var copyBtn = document.createElement("button");
    copyBtn.className = "copy";
    copyBtn.setAttribute("aria-label", "Copy install command");
    copyBtn.innerHTML = copySvg();
    copyBtn.addEventListener("click", function () {
      navigator.clipboard.writeText(activeCmd()).then(function () {
        copyBtn.innerHTML = checkSvg();
        setTimeout(function () { copyBtn.innerHTML = copySvg(); }, 1600);
      });
    });

    installOptions.forEach(function (opt) {
      var btn = document.createElement("button");
      btn.className = "tab";
      btn.textContent = opt.label;
      btn.addEventListener("click", function () {
        active = opt.id;
        tabs.querySelectorAll(".tab").forEach(function (b) { b.classList.remove("active"); });
        btn.classList.add("active");
        commandEl.innerHTML = renderCmd(opt.cmd);
      });
      if (opt.id === active) btn.classList.add("active");
      tabs.appendChild(btn);
    });

    function activeCmd() {
      return installOptions.filter(function (o) { return o.id === active; })[0].cmd;
    }
    function renderCmd(cmd) {
      return '<span class="prompt">$ </span>' + cmd;
    }

    commandEl.innerHTML = renderCmd(activeCmd());
    command.appendChild(commandEl);
    command.appendChild(copyBtn);
    wrap.appendChild(tabs);
    wrap.appendChild(command);
    mount.appendChild(wrap);
  }

  function copySvg() {
    return '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>';
  }
  function checkSvg() {
    return '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>';
  }

  // Responsive nav toggle.
  var toggler = document.getElementById("nav-toggle");
  var nav = document.getElementById("nav-links");
  if (toggler && nav) {
    toggler.addEventListener("click", function () {
      var open = nav.classList.toggle("collapsed") === false;
      toggler.setAttribute("aria-expanded", open ? "true" : "false");
    });
    // Collapse on small screens by default.
    if (window.matchMedia("(max-width: 640px)").matches) nav.classList.add("collapsed");
    nav.querySelectorAll("a").forEach(function (a) {
      a.addEventListener("click", function () { if (nav.classList.contains("collapsed")) nav.classList.remove("collapsed"); });
    });
  }

  // Year.
  var year = document.getElementById("year");
  if (year) year.textContent = new Date().getFullYear();

  renderInstallTabs();
})();
