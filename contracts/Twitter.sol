// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Twitter {
    address public owner;

    uint16 public Max_Tweetlength = 280;

    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    mapping(address => Tweet[]) public tweets;

    event TweetCreated(
        uint256 id,
        address author,
        string content,
        uint256 timestamp
    );
    event TweetLike(
        address liker,
        address tweetAuthor,
        uint256 tweetId,
        uint256 newLikeCount
    );
    event TweetUnlike(
        address unliker,
        address tweetAuthor,
        uint256 tweetId,
        uint256 newUnlikeCount
    );

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    function changeTweetLength(uint16 _Max_Tweetlength) public onlyOwner {
        Max_Tweetlength = _Max_Tweetlength;
    }

    function CreateTweet(string memory _tweet) public {
        require(
            bytes(_tweet).length <= Max_Tweetlength,
            "Tweet is too long bro!"
        );

        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });
        tweets[msg.sender].push(newTweet);

        emit TweetCreated(
            newTweet.id,
            newTweet.author,
            newTweet.content,
            newTweet.timestamp
        );
    }

    function likeTweek(address author, uint256 id) external {
        require(tweets[author][id].id == id, "Tweet does not exist");
        require(tweets[author][id].likes > 0, "Tweet has no likes");
        tweets[author][id].likes++;

        emit TweetLike(msg.sender, author, id, tweets[author][id].likes);
    }

    function unlikeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "Tweet does not exist");
        tweets[author][id].likes--;

        emit TweetUnlike(msg.sender, author, id, tweets[author][id].likes);
    }

    function getTweet(uint _i) public view returns (Tweet memory) {
        return tweets[msg.sender][_i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory) {
        return tweets[_owner];
    }
}
