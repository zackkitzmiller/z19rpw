import { check } from 'k6';
import http from 'k6/http';
export let options = {
  vus: 10,
};

export default function () {
  var res = http.get("https://z19r.pw/posts/sixpack-public-launch");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://z19r.pw/posts/whatever");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://z19r.pw/posts/cute-little-wsgi-error-handling-pattern");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://z19r.pw/posts/venuestagram");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://z19r.pw/posts/did-you-just-tell-me-to-go-fuck-myself");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://z19r.pw/posts/git-legit");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://z19r.pw/posts/go-fish");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://z19r.pw/posts/words-in-word");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://z19r.pw/posts/what-ive-been-watching");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://z19r.pw/posts/upgrading-to-mavericks-breaks-lxml");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://z19r.pw/posts/tiny-php");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://z19r.pw/posts/sending-email-with-laravel-sendgrid-beanstalkd-and-go");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://z19r.pw/posts/sixpack-version-1-1");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://z19r.pw/posts/zacks-beer-and-cheese-dip");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://z19r.pw/posts/things-at-seatgeek");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://z19r.pw/posts/testing-golang-apps-on-travisci-with-godep");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://z19r.pw/posts/the-six-types-of-zaaaa");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://z19r.pw/posts/getting-gpg-git-signing-working-with-fish-shell");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://z19r.pw/posts/mnesia-configuration-helper");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://z19r.pw/coffee");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://z19r.pw/blog?year=2014");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://z19r.pw/blog?year=2020");
  check(res, { 'status was 200': (r) => r.status == 200 });
}
