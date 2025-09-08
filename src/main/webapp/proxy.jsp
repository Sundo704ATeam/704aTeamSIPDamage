<%@ page import="java.net.*, java.io.*, java.util.*" contentType="application/octet-stream; charset=UTF-8" %>
<%
  request.setCharacterEncoding("UTF-8");

  String target = request.getParameter("url");
  if (target == null || target.isEmpty()) {
    response.setStatus(400);
    response.setContentType("application/json;charset=UTF-8");
    out.print("{\"error\":\"missing url\"}");
    return;
  }

  URL u;
  try { u = new URL(target); }
  catch (MalformedURLException e) {
    response.setStatus(400);
    response.setContentType("application/json;charset=UTF-8");
    out.print("{\"error\":\"bad url\"}");
    return;
  }

  HttpURLConnection c = (HttpURLConnection) u.openConnection();
  c.setRequestMethod("GET");
  c.setRequestProperty("Accept", "*/*");
  c.setRequestProperty("User-Agent", "SIPDamage-Proxy/1.0");
  c.setConnectTimeout(10_000);
  c.setReadTimeout(30_000);

  int code = 502;
  InputStream is = null;
  try {
    code = c.getResponseCode();
    response.setStatus(code);

    // ① Content-Type만 그대로 전달
    String ct = c.getHeaderField("Content-Type");
    if (ct != null) response.setContentType(ct);

    // ② 나머지 헤더는 ASCII만 선별 전달 (ISO-8859-1 오류 회피)
    List<String> pass = Arrays.asList("Content-Encoding","Cache-Control","Expires","ETag","Last-Modified");
    for (String h : pass) {
      String v = c.getHeaderField(h);
      if (v != null && v.chars().allMatch(ch -> ch <= 0xFF)) { // ISO-8859-1 안전
        response.setHeader(h, v);
      }
    }

    is = (200 <= code && code < 300) ? c.getInputStream() : c.getErrorStream();
    if (is != null) {
      ServletOutputStream os = response.getOutputStream();
      byte[] buf = new byte[8192];
      int n;
      while ((n = is.read(buf)) != -1) os.write(buf, 0, n);
      os.flush();
    }
  } catch (java.net.SocketTimeoutException tex) {
    response.setStatus(504);
    response.setContentType("application/json;charset=UTF-8");
    out.print("{\"error\":\"upstream timeout\"}");
  } finally {
    if (is != null) try { is.close(); } catch (Exception ignore) {}
    c.disconnect();
  }
%>
