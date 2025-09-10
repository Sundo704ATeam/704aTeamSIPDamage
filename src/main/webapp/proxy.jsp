<%@ page language="java" pageEncoding="UTF-8"
         contentType="application/octet-stream; charset=UTF-8"
         import="java.net.*, java.io.*, java.util.*" %>
<%
  request.setCharacterEncoding("UTF-8");

  String target = request.getParameter("url");
  if (target == null || target.isEmpty()) {
    response.setStatus(400);
    response.setContentType("application/json; charset=UTF-8");
    out.print("{\"error\":\"missing url\"}");
    return;
  }

  long t0 = System.nanoTime();
  URL u = new URL(target);
  HttpURLConnection c = (HttpURLConnection) u.openConnection();
  c.setRequestMethod("GET");
  c.setRequestProperty("Accept", "*/*");
  c.setRequestProperty("User-Agent", "SIPDamage-Proxy/1.0");
  c.setConnectTimeout(10000);
  c.setReadTimeout(30000);

  int code = 0;
  long bytes = 0L;
  InputStream is = null;
  try {
    code = c.getResponseCode();
    response.setStatus(code);

    // Content-Type은 그대로 쓰되, charset 부분은 강제로 UTF-8로 교체
    String ct = c.getHeaderField("Content-Type");
    if (ct != null) {
      if (ct.toLowerCase().contains("charset")) {
        ct = ct.replaceAll("(?i)charset=.+", "charset=UTF-8");
      } else {
        ct = ct + "; charset=UTF-8";
      }
      response.setContentType(ct);
    } else {
      response.setContentType("application/octet-stream; charset=UTF-8");
    }

    // ASCII 이외 문자가 있을 수 있는 헤더는 전달하지 않음 (ISO-8859-1 오류 방지)
    String[] safeHeaders = {"Content-Encoding","Cache-Control","Expires","ETag","Last-Modified"};
    for (String h : safeHeaders) {
      String v = c.getHeaderField(h);
      if (v != null && v.chars().allMatch(ch -> ch <= 0x7F)) {
        response.setHeader(h, v);
      }
    }

    is = (200 <= code && code < 300) ? c.getInputStream() : c.getErrorStream();
    if (is != null) {
      ServletOutputStream os = response.getOutputStream();
      byte[] buf = new byte[8192];
      int n;
      while ((n = is.read(buf)) != -1) {
        os.write(buf, 0, n);
        bytes += n;
      }
      os.flush();
    }
  } finally {
    if (is != null) try { is.close(); } catch (Exception ignore) {}
    c.disconnect();
    long ms = (System.nanoTime() - t0) / 1_000_000L;
    getServletContext().log(String.format(
      "PROXY url=%s status=%d bytes=%d timeMs=%d",
      target, code, bytes, ms
    ));
  }
%>
