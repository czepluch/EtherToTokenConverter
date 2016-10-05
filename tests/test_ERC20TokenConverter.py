# -*- coding: utf8 -*-
import pytest
from os.path import dirname, abspath, join, realpath

from ethereum import tester
from ethereum.utils import denoms
from ethereum.tester import ABIContract, ContractTranslator, TransactionFailed


def get_contract_path(contract_name):
    project_directory = dirname(dirname(abspath(__file__)))
    contract_path = join(project_directory, 'smart_contracts', contract_name)
    return realpath(contract_path)


def test_thirdparty():
    token_path = get_contract_path('ERC20EtherToken.sol')

    state = tester.state()
    token = state.abi_contract(
        None,
        path=token_path,
        language='solidity',
        constructor_parameters=["EtherToken", "ETT", "0.1"],
    )

    # initial state
    assert token.name() == "EtherToken"
    assert token.decimals() == 18
    assert token.symbol() == "ETT"
    assert token.version() == "0.1"
    assert token.totalSupply() == 0
    assert token.balanceOf(tester.a0) == 0
    assert token.contractBalance() == 0

    # check ether balance of a0
    assert token.getBalance() / denoms.ether == 999999

    # transfer ether to contract
    state.send(sender=tester.k0, to=token.address, value=10 * denoms.ether)
    # check updated contract balance
    assert token.contractBalance() == 10 * denoms.ether
    # check updated balance of tokens for a0
    assert token.balanceOf(tester.a0) == 10 * denoms.ether

    # check ether balance on a0
    assert token.getBalance() / denoms.ether == 999989

    # check total supply of tokens
    assert token.totalSupply() == 10 * denoms.ether
    assert token.amountOfTokensIssued() == 10 * denoms.ether

    with pytest.raises(tester.TransactionFailed):
        token.convertTokenToEther(11 * denoms.ether)

    # convert some tokens back to ether
    token.convertTokenToEther(9 * denoms.ether)
    assert token.contractBalance() == 1 * denoms.ether
    assert token.balanceOf(tester.a0) == 1 * denoms.ether
    assert token.getBalance() / denoms.ether == 999998  # some gas payed
    assert token.totalSupply() == 1 * denoms.ether

    with pytest.raises(tester.TransactionFailed):
        token.convertTokenToEther(2 * denoms.ether)

    token.convertTokenToEther(1 * denoms.ether)

    assert token.contractBalance() == 0 * denoms.ether
    assert token.balanceOf(tester.a0) == 0 * denoms.ether
    assert token.getBalance() / denoms.ether == 999999  # some gas payed
    assert token.totalSupply() == 0 * denoms.ether

