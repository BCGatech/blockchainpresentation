/*
Implements EIP20 token standard: https://github.com/ethereum/EIPs/issues/20
.*/


pragma solidity ^0.4.18;

import "./ERC20.sol";


contract BuzzToken is ERC20 {
    
    address private owner;
    bool public isRegistration;

    uint256 constant private MAX_UINT256 = 2**256 - 1;
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;
    /*
    NOTE:
    The following variables are OPTIONAL vanities. One does not have to include them.
    They allow one to customise the token contract & in no way influences the core functionality.
    Some wallets/interfaces might not even bother to look at this information.
    */
    string public name;                   //fancy name: eg Simon Bucks
    uint8 public decimals;                //How many decimals to show.
    string public symbol;                 //An identifier: eg SBX
    
    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }
    modifier registration() {
        require(isRegistration);
        _;
    }
    modifier erc20() {
        require(!isRegistration);
        _;
    }

    function BuzzToken(
        //uint256 _initialAmount,
        //string _tokenName,
        //uint8 _decimalUnits,
        //string _tokenSymbol
    ) public {
        owner = msg.sender;
        isRegistration = true;
        
        balances[msg.sender] = 0;//_initialAmount;               // Give the creator all initial tokens
        totalSupply = 0;//_initialAmount;                        // Update total supply
        name = "BuzzToken";//_tokenName;                                   // Set the name for display purposes
        decimals = 2;//_decimalUnits;                            // Amount of decimals for display purposes
        symbol = "BUZZ";//_tokenSymbol;                               // Set the symbol for display purposes
    }
    
    function register() public registration {
        balances[msg.sender] = 100;
    }
    
    function checkRegistration() public registration view returns(bool) {
        return(balances[msg.sender] == 100);
    }
    
    function endRegistration() public ownerOnly registration {
        isRegistration = false;
    }

    function transfer(address _to, uint256 _value) public erc20 returns (bool success) {
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public erc20 returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        if (allowance < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public erc20 view returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public erc20 returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public erc20 view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }   
}

