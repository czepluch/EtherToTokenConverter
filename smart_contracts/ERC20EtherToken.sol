import "StandardToken.sol";

contract ERC20EtherToken is StandardToken {

    string public name;
    uint8 public decimals;
    string public symbol;
    string public version = 'H0.1';

    event TokensCreated(address receiver, uint amountInWei);
    event EtherRedeemed(address receiver, uint amountInWei);

    modifier hasBalance(uint _amount) {
        if (balances[msg.sender] < _amount) throw;
        _//;
    }

    /// @notice Contructor for the token.
    /// @dev Constructor that takes different arguments to determine specifications of the token
    /// @param _name (string) name of the token
    /// @param _symbol (string) symbol of the token
    /// @param _version (string) version of the token
    function ERC20EtherToken(string _name, string _symbol, string _version) {
        name = _name;
        decimals = 18;
        symbol= _symbol;
        version = _version;
    }

    /// @notice function for receiving ether value
    /// @dev function that receives ether and issues tokens corresponding to the amount of ether
    //function() payable {
    function() {
        uint amount = msg.value;
        balances[msg.sender] += amount;
        totalSupply += amount;
        TokensCreated(msg.sender, amount);
    }

    /// @notice Get the total amount of tokens issued
    /// @dev Total amount of tokens issued
    /// @return balance (uint) the amount of tokens issued
    function amountOfTokensIssued() constant returns (uint balance) {
        balance = totalSupply;
    }

    /// @notice Redeem tokens for ether
    /// @dev Redeem tokens for ether
    /// @param amount (uint) the amount of tokens to redeem
    /// @return (bool) to show that transfer was successful
    function convertTokenToEther(uint amount) hasBalance(amount) returns (bool) {
        balances[msg.sender] -= amount;
        if (!msg.sender.send(amount)) throw;
        totalSupply -= amount;
        EtherRedeemed(msg.sender, amount);
        return true;
    }
}
