pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract TaskList {

	struct Task {
		string name;
		uint32 timestamp;
		bool isDone;
	}
	int8 tail = 0;
	int8 countOfOpenTasks = 0;
	mapping(int8 => Task) taskList;

	constructor() public {
		require(tvm.pubkey() != 0, 101);
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
	}

	modifier checkOwnerAndAccept {
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

	function addTask(string name) public checkOwnerAndAccept {
		require(name!="");
		tail++;
		taskList[tail] = Task(name, now, false);
		countOfOpenTasks++;
	}

	function countOfOpenTasksNumber() public checkOwnerAndAccept returns (int8) {
		return countOfOpenTasks;
	}

	function getTasks() public checkOwnerAndAccept returns (mapping(int8 => Task)) {
		return taskList;
	}

	function getTaskById(int8 taskId) public checkOwnerAndAccept returns (Task) {
		return (taskList[taskId]);
	}

	function deleteTaskById(int8 taskId) public checkOwnerAndAccept {
		if (!taskList[taskId].isDone) { countOfOpenTasks--; }
		    delete taskList[taskId];
	}

	function closeTaskById(int8 taskId) public checkOwnerAndAccept {
		taskList[taskId].isDone = true;
		countOfOpenTasks--;
	}

}