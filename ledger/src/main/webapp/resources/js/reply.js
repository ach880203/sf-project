(function () {
  var cfg = window.REPLY_CFG || {};
  var ctx = cfg.ctx || "";
  var bno = Number(cfg.bno || 0);
  var size = Number(cfg.size || 10);

  var replyForm = document.querySelector("#replyForm");
  var replyList = document.querySelector(".replyList");
  var replyPaging = document.querySelector(".replyPaging");

  if (!replyForm || !replyList || !replyPaging || !bno) {
    console.error("reply.js: required elements missing or bno invalid", { bno: bno });
    return;
  }

  var replyModalEl = document.querySelector("#replyModal");
  var replyModForm = document.querySelector("#replyModForm");
  var modal = (replyModalEl && window.bootstrap) ? new bootstrap.Modal(replyModalEl) : null;

  var currentPage = 1;

  function url(path) {
    return ctx + path;
  }

  function esc(str) {
    if (str === null || str === undefined) return "";
    return String(str).replace(/[&<>"']/g, function (m) {
      return ({
        "&": "&amp;",
        "<": "&lt;",
        ">": "&gt;",
        '"': "&quot;",
        "'": "&#39;"
      })[m];
    });
  }

  // null 병합(??) 대체
  function pick(obj, keys, def) {
    for (var i = 0; i < keys.length; i++) {
      var k = keys[i];
      if (obj && obj[k] !== null && obj[k] !== undefined) return obj[k];
    }
    return def;
  }

  // ---------------- 등록 ----------------
  replyForm.addEventListener("submit", function (e) {
    e.preventDefault();
    e.stopPropagation();

    var replyText = (replyForm.replyText.value || "").trim();
    if (!replyText) return;

    axios.post(url("/replies"), { bno: bno, replyText: replyText })
      .then(function () {
        replyForm.replyText.value = "";
        loadReplies(1);
      })
      .catch(function (err) {
        console.error("add reply fail", err);
        alert("댓글 등록 실패(콘솔 확인)");
      });
  });

  // ---------------- 목록 ----------------
  function loadReplies(page) {
    axios.get(url("/replies/" + bno + "/list"), { params: { page: page, size: size } })
      .then(function (res) {
        currentPage = page;
        var data = res.data || {};
        renderReplies(data.communityReplyDTOList || data.list || []);
        renderPaging(data);
      })
      .catch(function (err) {
        console.error("list fail", err);
        alert("댓글 목록 조회 실패(콘솔 확인)");
      });
  }

  function renderReplies(list) {
    if (!list || list.length === 0) {
      replyList.innerHTML =
        '<li class="list-group-item text-center text-muted">아직 댓글이 없습니다.</li>';
      return;
    }

    var html = "";
    for (var i = 0; i < list.length; i++) {
      var r = list[i];

      var text = esc(pick(r, ["replyText", "replytext"], ""));
      var date = esc(pick(r, ["replyDate", "replydate", "regDate", "regdate"], ""));
      var who  = esc(pick(r, ["replyer", "replyWriter", "writer"], ""));

      html += ''
        + '<li class="list-group-item reply-item" data-rno="' + r.rno + '">'
		+ '  <div class="d-flex justify-content-between">'
		+ '    <div><strong>' + who + '</strong></div>'
		+ '    <div class="text-muted small">' + date + '</div>'
		+ '  </div>'
		+ '  <div class="mt-1">' + text + '</div>'
        + '</li>';
    }

    replyList.innerHTML = html;
  }


  // ---------------- 페이징 ----------------
  function renderPaging(data) {
    if (!data || !data.pageNums) {
      replyPaging.innerHTML = "";
      return;
    }

    var html = "";

    if (data.prev) {
      html += '<li class="page-item"><a class="page-link" href="' + (data.start - 1) + '">Prev</a></li>';
    }

    for (var i = 0; i < data.pageNums.length; i++) {
      var num = data.pageNums[i];
      var active = (data.page === num) ? "active" : "";
      html += '<li class="page-item ' + active + '">'
        + '<a class="page-link" href="' + num + '">' + num + '</a>'
        + '</li>';
    }

    if (data.next) {
      html += '<li class="page-item"><a class="page-link" href="' + (data.end + 1) + '">Next</a></li>';
    }

    replyPaging.innerHTML = html;
  }

  replyPaging.addEventListener("click", function (e) {
    e.preventDefault();
    var target = e.target;
    if (!target) return;

    var page = target.getAttribute("href");
    if (!page) return;

    loadReplies(Number(page));
  });

  // ---------------- 모달 ----------------
  replyList.addEventListener("click", function (e) {
    var target = e.target;
    if (!target) return;

    var li = target.closest ? target.closest(".reply-item") : null;
    if (!li) return;

    var rno = li.getAttribute("data-rno");

    axios.get(url("/replies/" + rno))
      .then(function (res) {
        if (!replyModForm || !modal) return;

        var dto = res.data || {};
        replyModForm.querySelector("[name=rno]").value = dto.rno;
        replyModForm.querySelector("[name=replyText]").value = pick(dto, ["replyText", "replytext"], "");
        modal.show();
      })
      .catch(function (err) {
        console.error("read fail", err);
        alert("댓글 조회 실패(콘솔 확인)");
      });
  });

  var btnMod = document.querySelector(".btnReplyMod");
  if (btnMod) {
    btnMod.addEventListener("click", function () {
      if (!replyModForm) return;
      var rno = replyModForm.querySelector("[name=rno]").value;
      var replyText = (replyModForm.querySelector("[name=replyText]").value || "").trim();
      if (!rno || !replyText) return;

      axios.put(url("/replies/" + rno), { replyText: replyText })
        .then(function () {
          if (modal) modal.hide();
          loadReplies(currentPage);
        })
        .catch(function (err) {
          console.error("modify fail", err);
          alert("댓글 수정 실패(콘솔 확인)");
        });
    });
  }

  var btnDel = document.querySelector(".btnReplyDel");
  if (btnDel) {
    btnDel.addEventListener("click", function () {
      if (!replyModForm) return;
      var rno = replyModForm.querySelector("[name=rno]").value;
      if (!rno) return;

      axios.delete(url("/replies/" + rno))
        .then(function () {
          if (modal) modal.hide();
          loadReplies(currentPage);
        })
        .catch(function (err) {
          console.error("delete fail", err);
          alert("댓글 삭제 실패(콘솔 확인)");
        });
    });
  }

  // 최초 로딩
  loadReplies(1);
})();
