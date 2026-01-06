// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Todo} from "../src/Todo.sol";

contract TodoTest is Test {
    Todo public todo;
    address user = vm.addr(1);
    address user2 = vm.addr(2);

    function setUp() public {
        todo = new Todo();
    }

    function test_addTask() public {
        vm.startPrank(user);

        todo.addTask("Mandi");

        (
            uint256 id,
            string memory task,
            address creator,
            bool status,
            bool isDeleted
        ) = todo.tasks(1);

        assertEq(id, 1);
        assertEq(task, "Mandi");
        assertEq(creator, user);
        assertEq(status, false);
        assertEq(isDeleted, false);
        assertEq(todo.count(), 1);
        assertEq(todo.userTasks(user), 1);
    }

    function test_addBlankTask() public {
        vm.expectRevert("Task Kosong.");
        todo.addTask("");
    }

    function test_editTask() public {
        todo.addTask("Mandi");

        (, string memory task, , , ) = todo.tasks(1);
        assertEq(task, "Mandi");

        todo.editTask(1, "Mandi Pagi");
        (, string memory newTask, , , ) = todo.tasks(1);
        assertEq(newTask, "Mandi Pagi");
    }

    function test_editBlankTask() public {
        todo.addTask("Mandi");

        (, string memory task, , , ) = todo.tasks(1);
        assertEq(task, "Mandi");

        vm.expectRevert("Task Kosong.");
        todo.editTask(1, "");
    }

    function test_editNonExistingTask() public {
        vm.expectRevert("Task tidak ada.");
        todo.editTask(1, "");
    }

    function test_editTaskNotOwner() public {
        vm.startPrank(user);
        todo.addTask("Mandi");
        vm.stopPrank();
        vm.expectRevert("Not the owner of the task!");
        todo.editTask(1, "XXX");
    }

    function test_completeTask() public {
        todo.addTask("Mandi");
        todo.completeTask(1);

        (, , , bool status, ) = todo.tasks(1);
        assertTrue(status);
    }

    function test_completeNonExistingTask() public {
        vm.expectRevert("Task tidak ada.");
        todo.completeTask(1);
    }

    function test_completeTaskNotOwner() public {
        vm.startPrank(user);
        todo.addTask("Mandi");
        vm.stopPrank();
        vm.expectRevert("Not the owner of the task!");
        todo.completeTask(1);
    }

    function test_deleteTask() public {
        todo.addTask("Mandi");
        todo.deleteTask(1);

        (, , , , bool isDeleted) = todo.tasks(1);
        assertTrue(isDeleted);
    }

    function test_deleteNonExistingTask() public {
        vm.expectRevert("Task tidak ada.");
        todo.deleteTask(1);
    }

    function test_deleteTaskNotOwner() public {
        vm.startPrank(user);
        todo.addTask("Mandi");
        vm.stopPrank();
        vm.expectRevert("Not the owner of the task!");
        todo.deleteTask(1);
    }
}
