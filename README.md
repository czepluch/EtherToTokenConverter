# EtherToTokenConverter
Smart contract for creating ether backed tokens

Idea is to have a token that represents ether to be used with Raiden or other token based systems. 

1 ether will convert into 1 token. Tokens should have 18 decimals in order to be directly mapped to ether.

The token follows the ERC20 standard and builds on top of the Consensys implementation of this standard.


## To run tests

Please use a fresh python virtualenv

`pip install ethereum`

`pip install pytest`
