import { check } from 'k6';
import http from 'k6/http';
export let options = {
  vus: 10,
};

export default function () {
  var res = http.get("https://blob.z19r.pw/public/kitz.jpg");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://blob.z19r.pw/public/venmo.png");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://blob.z19r.pw/public/gbo.png");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://blob.z19r.pw/public/forrst.png");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://blob.z19r.pw/public/seatgeek.png");
  check(res, { 'status was 200': (r) => r.status == 200 });

  var res = http.get("https://contentdeliverynetwork.z19r.pw/assets/kitz.jpg");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://contentdeliverynetwork.z19r.pw/assets/venmo.png");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://contentdeliverynetwork.z19r.pw/assets/gbo.png");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://contentdeliverynetwork.z19r.pw/assets/forrst.png");
  check(res, { 'status was 200': (r) => r.status == 200 });
  var res = http.get("https://contentdeliverynetwork.z19r.pw/assets/seatgeek.png");
  check(res, { 'status was 200': (r) => r.status == 200 });

}
