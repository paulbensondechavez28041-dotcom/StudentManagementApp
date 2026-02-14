<?php
include 'initialize.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

// Preflight
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

try {

    $method = $_SERVER['REQUEST_METHOD'];
    $data = json_decode(file_get_contents("php://input"), true);

    // ---------- GET (Fetch all students) ----------
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

    // ---------- POST (Add student) ----------
    if ($method === 'POST') {

        if (
            empty($data['name']) ||
            empty($data['course']) ||
            empty($data['yearLevel'])
        ) {
            http_response_code(400);
            throw new Exception("All fields are required");
        }

        $stmt = $connection->prepare(
            "INSERT INTO students (name, course, yearLevel) VALUES (?, ?, ?)"
        );
        $stmt->bind_param(
            "sss",
            $data['name'],
            $data['course'],
            $data['yearLevel']
        );

        if (!$stmt->execute()) {
            throw new Exception($stmt->error);
        }

        echo json_encode([
            "success" => true,
            "message" => "Student added successfully",
            "data" => [
                "id" => $stmt->insert_id,
                "name" => $data['name'],
                "course" => $data['course'],
                "yearLevel" => $data['yearLevel']
            ]
        ], JSON_PRETTY_PRINT);
        exit();
    }

    // ---------- PUT (Update student) ----------
    if ($method === 'PUT') {

        if (empty($data['id'])) {
            throw new Exception("Student ID required");
        }

        $stmt = $connection->prepare(
            "UPDATE students SET name=?, course=?, yearLevel=? WHERE id=?"
        );
        $stmt->bind_param(
            "sssi",
            $data['name'],
            $data['course'],
            $data['yearLevel'],
            $data['id']
        );

        if (!$stmt->execute()) {
            throw new Exception($stmt->error);
        }

        echo json_encode([
            "success" => true,
            "message" => "Student updated"
        ], JSON_PRETTY_PRINT);
        exit();
    }

    // ---------- DELETE ----------
    if ($method === 'DELETE') {

        if (empty($data['id'])) {
            throw new Exception("Student ID required");
        }

        $stmt = $connection->prepare(
            "DELETE FROM students WHERE id=?"
        );
        $stmt->bind_param("i", $data['id']);

        if (!$stmt->execute()) {
            throw new Exception($stmt->error);
        }

        echo json_encode([
            "success" => true,
            "message" => "Student deleted"
        ], JSON_PRETTY_PRINT);
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
