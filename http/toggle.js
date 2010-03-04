<%init>
my $root = Apache->request->dir_config('Path');
</%init>
function toggleDate(day) {
  var e = document.getElementById("d." + day);

  var loc = "<% $root %>/ToggleDate?d=" + day;

  if (window.XMLHttpRequest) {
    liveSearchReq = new XMLHttpRequest();
  } else if (window.ActiveXObject) {
    liveSearchReq = new ActiveXObject("Microsoft.XMLHTTP");
  }

  liveSearchReq.onreadystatechange = liveSearchReq.onload = function() {
      updateElem(liveSearchReq, e)
  };
  liveSearchReq.open("GET", loc);
  liveSearchReq.send(null);
  return false;
}

function toggleTime(hour,day) {
  var e = document.getElementById("h." + hour + "." + day);

  var loc = "<% $root %>/ToggleTime?h="+hour+"&d="+day;

  if (window.XMLHttpRequest) {
    liveSearchReq = new XMLHttpRequest();
  } else if (window.ActiveXObject) {
    liveSearchReq = new ActiveXObject("Microsoft.XMLHTTP");
  }

  liveSearchReq.onreadystatechange = liveSearchReq.onload = function() {
      updateElem(liveSearchReq, e)
  };
  liveSearchReq.open("GET", loc);
  liveSearchReq.send(null);
  return false;
}

function updateElem(liveSearchReq, e) {
  if (liveSearchReq.readyState == 4) {
    e.innerHTML = liveSearchReq.responseText;
  }
}
