<?php


// =====================================================================
// Please specify the title of the licensing page.
// =====================================================================
$page_title = $application_name." ".$application_version." - ".$application_description;


// =====================================================================
// Please specify if an application log should be created. This logfile
// will collect some information when a user creates a trial license.
// =====================================================================
$use_application_log = 1;


// =====================================================================
// Please specify if product logfiles should be used to check if the
// user has created a trial license before. If the e-mail address was
// used before, for the same product, no new trial license will be
// created and an error message will be displayed.
// =====================================================================
$use_product_log = 1;


// =====================================================================
// Please specify if date logfile should be created. This logfile will
// collect some information when a license is validated via the script
// 'date.php' which sends the actual date to the license validator.
// =====================================================================
$use_date_log = 1;


// =====================================================================
// Specify the logfile directory.
// =====================================================================
$log_file_dir = "log";


// =====================================================================
// Please specify the sender name which is used for sending the license
// confirmation e-mail to the user.
// =====================================================================
$sender_name = "PBprotect Admin";


// =====================================================================
// Please specify the sender e-mail address which is used for sending
// the license confirmation e-mail to the user.
// =====================================================================
$sender_email = "admin@pb-soft.com";


// =====================================================================
// Please specify the product names.
// =====================================================================
$appl_name[0] = "PBoptimizer";
$appl_name[1] = "PBpassword";
$appl_name[2] = "PBbookmarks";


// =====================================================================
// Please specify the product versions.
// =====================================================================
$appl_version[0] = "2.0";
$appl_version[1] = "1.5";
$appl_version[2] = "1.2";


// =====================================================================
// Please specify the product hash types.
// =====================================================================
$hash_type[0] = 4;
$hash_type[1] = 3;
$hash_type[2] = 5;


// =====================================================================
// Please specify the product trial duration in days.
// =====================================================================
$duration[0] = 14;
$duration[1] = 7;
$duration[2] = 30;
