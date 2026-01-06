// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Todo {
    struct Task {
        uint256 id;
        string task;
        bool status;
    }

    uint256 public count;

    mapping(uint256 => Task) public tasks;

    event TaskAdded(uint256 id, string task, bool status);

    event TaskFinished(uint256 id, bool status);

    function addTask(string memory _task) public {
        count++;
        tasks[count] = Task(count, _task, false);
        emit TaskAdded(count, _task, false);
    }

    function completeTask(uint256 _id) public {
        Task storage _task = tasks[_id];
        _task.status = !_task.status;
        emit TaskFinished(_id, _task.status);
    }
}
