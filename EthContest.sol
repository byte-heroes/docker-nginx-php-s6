pragma solidity ^0.5.12;

contract ContestsHandler {
    struct Contest {
        string id;
        uint256 buyin;
        mapping(address => bool) participants;
        mapping(address => bool) paidParticipants;
    }

    uint256 public contestsCount = 0;
    mapping(uint => Contest) public contests;
    mapping(string => uint) public contestsIndices;
    mapping(address => bool) private providerRakeAddresses;

    event Participated(address participantAddress, string contestId);

    event WinnerPaid(address participantAddress, string contestId);

    //constructor
    function ContestsHandler() {}

    //Add new additional provider rake address
    function addProviderRakeAddress(address _newProviderRakeAddress) public {
    	providerRakeAddresses[_newProviderRakeAddress] = true;
    }

    //create a new contest
    function createContest(string _contestId, uint256 _buyin) public {
    	//this starts with 1 because when we check if a contest ID exists and it does not, then it will return 0. So no contest on index zero is allowed.
    	contestsCount = contestsCount+1;

    	contests[contestsCount] = Contest(_contestId, _buyin);
    	contestsIndices[_contestId] = contestsCount;
    }

    //buy into a contest
    function participate(string _contestId) public payable {
    	// Here we are making sure that there isn't an overflow issue
    	require((balances[msg.sender] + msg.value) >= balances[msg.sender], "Balance of participant is not high enough");

    	//check if given contest exists
    	require(contestsIndices[_contestId] > 0, "The contest with given ID does not exist");

    	//check if sent value is exactly the buy-in of given
    	require(msg.value == contests[contestsIndices[_contestId]].buyin, "The sent ETH amount is not equal to the buy-in value of this contest");

    	//check if sender is already participant of given contest
    	require(contests[contestsIndices[_contestId]].participants[msg.sender] == false, "Given address is already participant in this contest");

        participants[contests[contestsIndices[_contestId]].participants[msg.sender] = true;
        emit Participated(msg.sender, _contestId);
    }

    //check if given address is a participant of given contest
    function isParticipant(string _contestId, address _parcticipant) public view returns bool {
    	//check if given contest exists
    	require(contestsIndices[_contestId] > 0, "The contest with given ID does not exist");

    	return contests[contestsIndices[_contestId]].participants[_participant];
    }

    //check if given address is already paid by given contest
    function isPaid(string _contestId, address _parcticipant) public view returns bool {
    	//check if given contest exists
    	require(contestsIndices[_contestId] > 0, "The contest with given ID does not exist");

    	return contests[contestsIndices[_contestId]].paidParticipants[_participant];
    }

    // pay out to multiple participants with the same amount
    function payoutMultiSimple(string _contestId, address[] _to, uint256 _amount) public {
    	//check if given contest exists
    	require(contestsIndices[_contestId] > 0, "The contest with given ID does not exist");

        uint256 addressCount = _to.length;
        for (uint256 i = 0; i < addressCount; i++) {
            payout(_contestId, _to[i], _amount);
        }
    }

    //payout to one address
    function payout(string _contestId, address _to, uint256 _amount) public {
    	//check if given contest exists
    	require(contestsIndices[_contestId] > 0, "The contest with given ID does not exist");

    	if(providerRakeAddresses[_to] == false) {
    		//check if address is participant in the contest
    		require(contests[contestsIndices[_contestId]].participants[_participant] == true, "Given address is not a participant of this contest");

    		//check if participant is already paid
    		require(contests[contestsIndices[_contestId]].paidParticipants[_to] == false, "Given address has already received payment");
    	}
    	

    	//send the funds to the winner
        _to.transfer(_amount);

        contests[contestsIndices[_contestId]].paidParticipants[_to] = true;
        emit WinnerPaid(_to, _contestId);
    }
}