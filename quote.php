<?php
// Nomcebo Printers - quote form handler
$to = 'quotes@nomceboprinters.co.za';
if ($_SERVER['REQUEST_METHOD'] !== 'POST' || !empty($_POST['website'])) { header('Location: index.html'); exit; }
function clean($v) { return trim(preg_replace('/[\r\n]+/', ' ', strip_tags((string)$v))); }
$name    = clean($_POST['name'] ?? '');
$contact = clean($_POST['contact'] ?? '');
$service = clean($_POST['service'] ?? '');
$details = trim(strip_tags((string)($_POST['details'] ?? '')));
if ($name === '' || $contact === '' || $service === '') { header('Location: index.html?error=1#quote'); exit; }
$subject = 'Website quote request: ' . mb_substr($service, 0, 80);
$body    = "Name: $name\nContact: $contact\nService: $service\n\nDetails:\n$details\n";
$headers = "From: Nomcebo Printers Website <no-reply@nomceboprinters.co.za>\r\n";
if (filter_var($contact, FILTER_VALIDATE_EMAIL)) { $headers .= "Reply-To: $contact\r\n"; }
$ok = mail($to, $subject, $body, $headers);
header('Location: index.html?' . ($ok ? 'sent=1' : 'error=1') . '#quote');
exit;
