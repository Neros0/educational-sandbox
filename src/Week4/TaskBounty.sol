// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title TaskBounty
 * @dev A contract for posting tasks with rewards, submitting solutions, and claiming bounties
 * @notice This contract is for educational purposes - allows duplicate tasks and basic bounty system
 */
contract TaskBounty {
    struct Task {
        uint256 id;
        address creator;
        string title;
        string description;
        uint256 reward;
        bool isCompleted;
        bool isActive;
        uint256 createdAt;
        address solver;
        string solution;
        uint256 solvedAt;
    }

    struct Submission {
        uint256 taskId;
        address submitter;
        string solution;
        uint256 submittedAt;
        bool isAccepted;
    }

    // State variables
    uint256 private nextTaskId;
    uint256 private nextSubmissionId;

    mapping(uint256 => Task) public tasks;
    mapping(uint256 => Submission) public submissions;
    mapping(uint256 => uint256[]) public taskSubmissions; // taskId => submission IDs
    mapping(address => uint256[]) public userTasks; // user => task IDs created
    mapping(address => uint256[]) public userSubmissions; // user => submission IDs

    // Events
    event TaskCreated(uint256 indexed taskId, address indexed creator, string title, uint256 reward);

    event SolutionSubmitted(
        uint256 indexed taskId, uint256 indexed submissionId, address indexed submitter, string solution
    );

    event BountyClaimed(uint256 indexed taskId, uint256 indexed submissionId, address indexed solver, uint256 reward);

    event TaskDeactivated(uint256 indexed taskId, address indexed creator);

    // Modifiers
    modifier onlyTaskCreator(uint256 _taskId) {
        require(tasks[_taskId].creator == msg.sender, "Only task creator can perform this action");
        _;
    }

    modifier taskExists(uint256 _taskId) {
        require(_taskId < nextTaskId, "Task does not exist");
        _;
    }

    modifier taskActive(uint256 _taskId) {
        require(tasks[_taskId].isActive, "Task is not active");
        require(!tasks[_taskId].isCompleted, "Task is already completed");
        _;
    }

    modifier submissionExists(uint256 _submissionId) {
        require(_submissionId < nextSubmissionId, "Submission does not exist");
        _;
    }

    /**
     * @dev Create a new task with reward
     * @param _title Title of the task
     * @param _description Detailed description of the task
     * @notice Reward is sent with the transaction (msg.value). Accepts 0 or greater.
     */
    function createTask(string calldata _title, string calldata _description) external payable {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");

        uint256 taskId = nextTaskId++;

        tasks[taskId] = Task({
            id: taskId,
            creator: msg.sender,
            title: _title,
            description: _description,
            reward: msg.value,
            isCompleted: false,
            isActive: true,
            createdAt: block.timestamp,
            solver: address(0),
            solution: "",
            solvedAt: 0
        });

        userTasks[msg.sender].push(taskId);

        emit TaskCreated(taskId, msg.sender, _title, msg.value);
    }

    /**
     * @dev Submit a solution for a task
     * @param _taskId ID of the task to submit solution for
     * @param _solution The proposed solution
     */
    function submitSolution(uint256 _taskId, string calldata _solution)
        external
        taskExists(_taskId)
        taskActive(_taskId)
    {
        require(bytes(_solution).length > 0, "Solution cannot be empty");
        require(msg.sender != tasks[_taskId].creator, "Task creator cannot submit solution");

        uint256 submissionId = nextSubmissionId++;

        submissions[submissionId] = Submission({
            taskId: _taskId,
            submitter: msg.sender,
            solution: _solution,
            submittedAt: block.timestamp,
            isAccepted: false
        });

        taskSubmissions[_taskId].push(submissionId);
        userSubmissions[msg.sender].push(submissionId);

        emit SolutionSubmitted(_taskId, submissionId, msg.sender, _solution);
    }

    /**
     * @dev Accept a solution and award the bounty
     * @param _submissionId ID of the submission to accept
     */
    function acceptSolution(uint256 _submissionId) external submissionExists(_submissionId) {
        Submission storage submission = submissions[_submissionId];
        uint256 taskId = submission.taskId;
        Task storage task = tasks[taskId];

        require(msg.sender == task.creator, "Only task creator can accept solutions");
        require(task.isActive, "Task is not active");
        require(!task.isCompleted, "Task is already completed");
        require(!submission.isAccepted, "Submission already accepted");

        // Update task
        task.isCompleted = true;
        task.solver = submission.submitter;
        task.solution = submission.solution;
        task.solvedAt = block.timestamp;

        // Update submission
        submission.isAccepted = true;

        // Transfer reward to solver
        if (task.reward > 0) {
            payable(submission.submitter).transfer(task.reward);
        }

        emit BountyClaimed(taskId, _submissionId, submission.submitter, task.reward);
    }

    /**
     * @dev Deactivate a task (only creator can do this)
     * @param _taskId ID of the task to deactivate
     */
    function deactivateTask(uint256 _taskId) external taskExists(_taskId) onlyTaskCreator(_taskId) {
        Task storage task = tasks[_taskId];
        require(task.isActive, "Task is already inactive");
        require(!task.isCompleted, "Cannot deactivate completed task");

        task.isActive = false;

        // Refund reward to creator
        if (task.reward > 0) {
            payable(task.creator).transfer(task.reward);
        }

        emit TaskDeactivated(_taskId, msg.sender);
    }

    /**
     * @dev Get task details
     * @param _taskId ID of the task
     * @return Task struct
     */
    function getTask(uint256 _taskId) external view taskExists(_taskId) returns (Task memory) {
        return tasks[_taskId];
    }

    /**
     * @dev Get submission details
     * @param _submissionId ID of the submission
     * @return Submission struct
     */
    function getSubmission(uint256 _submissionId)
        external
        view
        submissionExists(_submissionId)
        returns (Submission memory)
    {
        return submissions[_submissionId];
    }

    /**
     * @dev Get all submission IDs for a task
     * @param _taskId ID of the task
     * @return Array of submission IDs
     */
    function getTaskSubmissions(uint256 _taskId) external view taskExists(_taskId) returns (uint256[] memory) {
        return taskSubmissions[_taskId];
    }

    /**
     * @dev Get all task IDs created by a user
     * @param _user Address of the user
     * @return Array of task IDs
     */
    function getUserTasks(address _user) external view returns (uint256[] memory) {
        return userTasks[_user];
    }

    /**
     * @dev Get all submission IDs by a user
     * @param _user Address of the user
     * @return Array of submission IDs
     */
    function getUserSubmissions(address _user) external view returns (uint256[] memory) {
        return userSubmissions[_user];
    }

    /**
     * @dev Get total number of tasks
     * @return Total task count
     */
    function getTotalTasks() external view returns (uint256) {
        return nextTaskId;
    }

    /**
     * @dev Get total number of submissions
     * @return Total submission count
     */
    function getTotalSubmissions() external view returns (uint256) {
        return nextSubmissionId;
    }

    /**
     * @dev Get active tasks (for pagination)
     * @param _offset Starting index
     * @param _limit Number of tasks to return
     * @return Array of task IDs that are active
     */
    function getActiveTasks(uint256 _offset, uint256 _limit) external view returns (uint256[] memory) {
        uint256 activeCount = 0;

        // Count active tasks
        for (uint256 i = 0; i < nextTaskId; i++) {
            if (tasks[i].isActive && !tasks[i].isCompleted) {
                activeCount++;
            }
        }

        if (_offset >= activeCount) {
            return new uint256[](0);
        }

        uint256 length = _limit;
        if (_offset + _limit > activeCount) {
            length = activeCount - _offset;
        }

        uint256[] memory result = new uint256[](length);
        uint256 currentIndex = 0;
        uint256 resultIndex = 0;

        for (uint256 i = 0; i < nextTaskId && resultIndex < length; i++) {
            if (tasks[i].isActive && !tasks[i].isCompleted) {
                if (currentIndex >= _offset) {
                    result[resultIndex] = i;
                    resultIndex++;
                }
                currentIndex++;
            }
        }

        return result;
    }

    /**
     * @dev Emergency function to withdraw any stuck ETH (only in case of bugs)
     * @notice This should only be used in emergency situations
     */
    function emergencyWithdraw() external {
        require(msg.sender == address(this), "Only contract can call this");
        payable(msg.sender).transfer(address(this).balance);
    }

    /**
     * @dev Get contract balance
     * @return Contract ETH balance
     */
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
