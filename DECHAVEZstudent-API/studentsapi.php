<?php
include 'initialize.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$method = $_SERVER['REQUEST_METHOD'];

try {

    // ---------- GET (Read) ----------
    if ($method === 'GET') {
        $result = $connection->query("SELECT * FROM students ORDER BY id DESC");
        $students = [];

        while ($row = $result->fetch_assoc()) {
            $students[] = $row;
        }

        echo json_encode([
            "success" => true,
            "data" => $students
        ], JSON_PRETTY_PRINT);
        exit();
    }

    // Get JSON body
    $input = json_decode(file_get_contents("php://input"), true);

    // ---------- POST (Create) ----------
    if ($method === 'POST') {
        if (empty($input['name']) || empty($input['course']) || empty($input['yearLevel'])) {
            http_response_code(400);
            throw new Exception("All fields are required");
        }

        $name = $connection->real_escape_string($input['name']);
        $course = $connection->real_escape_string($input['course']);
        $year = $connection->real_escape_string($input['yearLevel']);

        $sql = "INSERT INTO students (name, course, yearLevel)
                VALUES ('$name', '$course', '$year')";

        if ($connection->query($sql)) {
            echo json_encode([
                "success" => true,
                "message" => "Student added",
                "id" => $connection->insert_id
            ], JSON_PRETTY_PRINT);
        }
        exit();
    }

    // ---------- PUT (Update) ----------
    if ($method === 'PUT') {
        if (empty($input['id'])) {
            throw new Exception("Student ID required");
        }

        $id = (int)$input['id'];
        $name = $connection->real_escape_string($input['name']);
        $course = $connection->real_escape_string($input['course']);
        $year = $connection->real_escape_string($input['yearLevel']);

        $sql = "UPDATE students 
                SET name='$name', course='$course', yearLevel='$year'
                WHERE id=$id";

        if ($connection->query($sql)) {
            echo json_encode([
                "success" => true,
                "message" => "Student updated"
            ], JSON_PRETTY_PRINT);
        }
        exit();
    }

    // ---------- DELETE ----------
    if ($method === 'DELETE') {
        if (empty($input['id'])) {
            throw new Exception("Student ID required");
        }

        $id = (int)$input['id'];

        $sql = "DELETE FROM students WHERE id=$id";

        if ($connection->query($sql)) {
            echo json_encode([
                "success" => true,
                "message" => "Student deleted"
            ], JSON_PRETTY_PRINT);
        }
        exit();
    }

    http_response_code(405);
    throw new Exception("Method not allowed");

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "error" => $e->getMessage()
    ], JSON_PRETTY_PRINT);
}

$connection->close();
?>
