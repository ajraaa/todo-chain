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

    function test_completeTask() public {
        todo.addTask("Mandi");
        todo.completeTask(1);

        (, , bool status, ) = todo.tasks(1);
        assertTrue(status);
    }

    function test_deleteTask() public {
        todo.addTask("Mandi");
        todo.deleteTask(1);

        (, , , bool isDeleted) = todo.tasks(1);
        assertTrue(isDeleted);
    }
}
