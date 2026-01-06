// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Todo} from "../src/Todo.sol";

contract TodoTest is Test {
    Todo public todo;

    function setUp() public {
        todo = new Todo();
    }

    function test_addTask() public {
        todo.addTask("Mandi");

        (uint256 id, string memory task, bool status, bool isDeleted) = todo
            .tasks(1);

        assertEq(id, 1);
        assertEq(task, "Mandi");
        assertEq(status, false);
        assertEq(isDeleted, false);
        assertEq(todo.count(), 1);
    }

    function test_addBlankTask() public {
        vm.expectRevert("Task Kosong.");
        todo.addTask("");
    }

    function test_editTask() public {
        todo.addTask("Mandi");

        (, string memory task, , ) = todo.tasks(1);
        assertEq(task, "Mandi");

        todo.editTask(1, "Mandi Pagi");
        (, string memory newTask, , ) = todo.tasks(1);
        assertEq(newTask, "Mandi Pagi");
    }

    function test_editBlankTask() public {
        todo.addTask("Mandi");

        (, string memory task, , ) = todo.tasks(1);
        assertEq(task, "Mandi");

        vm.expectRevert("Task Kosong.");
        todo.editTask(1, "");
    }

    function test_editNonExistingTask() public {
        vm.expectRevert("Task tidak ada.");
        todo.editTask(1, "");
    }

    function test_completeTask() public {
        todo.addTask("Mandi");
        todo.completeTask(1);

        (, , bool status, ) = todo.tasks(1);
        assertTrue(status);
    }

    function test_completeNonExistingTask() public {
        vm.expectRevert("Task tidak ada.");
        todo.completeTask(1);
    }

    function test_deleteTask() public {
        todo.addTask("Mandi");
        todo.deleteTask(1);

        (, , , bool isDeleted) = todo.tasks(1);
        assertTrue(isDeleted);
    }

    function test_deleteNonExistingTask() public {
        vm.expectRevert("Task tidak ada.");
        todo.deleteTask(1);
    }
}
