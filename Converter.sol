import "StandardToken.sol";

contract Converter is StandardToken {

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

    function Converter(string _name, uint8 _decimals, string _symbol, string _version) {
        name = _name;
        if(_decimals == 0) decimals = 18; else {decimals = _decimals;}
        symbol= _symbol;
        version = _version;
    }

    //function() payable {
    function() {
        uint amount = msg.value;
        balances[msg.sender] += amount;
        totalSupply += amount;
        TokensCreated(msg.sender, amount);
    }

    function getEtherBalance() constant returns (uint balance) {
        balance = this.balance * 1 ether;
    }

    function getTokenBalance() constant returns (uint balance) {
        balance = balances[this] * 1 ether;
    }

    function convertTokenToEther(uint amount) hasBalance(amount) returns (bool) {
        balances[msg.sender] -= amount;
        if (!msg.sender.send(amount)) throw;
        EtherRedeemed(msg.sender, amount);
    }

}
