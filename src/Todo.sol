// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Todo {
    struct Task {
        uint256 id;
        string task;
        address creator;
        bool status;
        bool isDeleted;
    }

    uint256 public count;

    mapping(uint256 => Task) public tasks;
    mapping(address => uint256) public userTasks;

    event TaskAdded(
        uint256 id,
        string task,
        address creator,
        bool status,
        bool isDeleted
    );
    event TaskFinished(uint256 id, bool status);
    event TaskDeleted(uint256 id, bool isDeleted);
    event TaskEdited(uint256 id, string task);

    function addTask(string memory _task) public {
        require(bytes(_task).length > 0, "Task Kosong.");
        count++;
        tasks[count] = Task(count, _task, msg.sender, false, false);
        userTasks[msg.sender] = count;
        emit TaskAdded(count, _task, msg.sender, false, false);
    }

    function editTask(uint256 _id, string memory _newTask) public {
        require(_id > 0 && _id <= count, "Task tidak ada.");
        require(bytes(_newTask).length > 0, "Task Kosong.");
        Task storage _task = tasks[_id];
        _task.task = _newTask;
        emit TaskEdited(_id, _task.task);
    }

    function completeTask(uint256 _id) public {
        require(_id > 0 && _id <= count, "Task tidak ada.");
        Task storage _task = tasks[_id];
        _task.status = !_task.status;
        emit TaskFinished(_id, _task.status);
    }

    function deleteTask(uint256 _id) public {
        require(_id > 0 && _id <= count, "Task tidak ada.");
        Task storage _task = tasks[_id];
        _task.isDeleted = true;
        emit TaskDeleted(_id, _task.isDeleted);
    }
}
