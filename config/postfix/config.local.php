<?php
$CONF['configured'] = true;

$CONF['database_type'] = 'mysqli';
$CONF['database_host'] = 'db';
$CONF['database_user'] = 'root';
$CONF['database_password'] = 'root123';
$CONF['database_name'] = 'postfixadmin';

$CONF['default_aliases'] = array (
  'abuse'      => 'abuse@postfix_hostname',
  'hostmaster' => 'hostmaster@postfix_hostname',
  'postmaster' => 'postmaster@postfix_hostname',
  'webmaster'  => 'webmaster@postfix_hostname'
);

$CONF['fetchmail'] = 'NO';
$CONF['show_footer_text'] = 'NO';

$CONF['quota'] = 'YES';
$CONF['domain_quota'] = 'YES';
$CONF['quota_multiplier'] = '1024000';
$CONF['used_quotas'] = 'YES';
$CONF['new_quota_table'] = 'YES';

$CONF['aliases'] = '0';
$CONF['mailboxes'] = '0';
$CONF['maxquota'] = '0';
$CONF['domain_quota_default'] = '0';
?>
