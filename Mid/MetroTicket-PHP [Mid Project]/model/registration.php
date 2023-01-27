<?php
require_once 'database-config.php';

function register()
{
    $username = removeWhitespaces($_POST['username']);
    $password = removeWhitespaces($_POST['password']);
    $cPassword = removeWhitespaces($_POST['cPassword']);
    $email = removeWhitespaces($_POST['email']);
    $phone = removeWhitespaces($_POST['phone']);
    $managerId = $_POST['manager'];

    if (
        checkLength($username, 4)
        && filter_var($email, FILTER_VALIDATE_EMAIL)
        && checkLength($password, 5)
        && $password === $cPassword
        && validatePhone($phone)
        && $managerId > 0
    ) {
        $query = "INSERT INTO PASSENGER
                  VALUES (pass_seq.nextval, :username, :password, :email, :phone, :managerId)";
        try {
            $conn = oci_connect(USERNAME, PASSWORD, CONNECTION_STRING);

            $stid = oci_parse($conn, $query);

            oci_bind_by_name($stid, ":username", $username);
            oci_bind_by_name($stid, ":password", $password);
            oci_bind_by_name($stid, ":email", $email);
            oci_bind_by_name($stid, ":phone", $phone);
            oci_bind_by_name($stid, ":managerId", $managerId);

            oci_execute($stid);

            header("Location: ../view/register.php?success");
            die();

        } catch (Exception $ex) {
            header("Location: ../view/database-error.php");
            die();
        }
    }

    return false;
}

function checkLength($string, $minLength = 3, $maxLength = 16)
{
    $length = strlen($string);
    return $length > $minLength && $length < $maxLength;
}

function removeWhitespaces($string)
{
    return preg_replace('/\s+/', '', $string);
}

function validatePhone($phone)
{
    $regex = "/^(?:(?:\+|0{0,2})91(\s*[\ -]\s*)?|[0]?)?[456789]\d{9}|(\d[ -]?){10}\d$/";
    return preg_match($regex, $phone);
}