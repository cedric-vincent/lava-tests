#!/usr/bin/python

import pexpect
import sys
import time


def stmc_status_ok(stmcconfig, stmc_ip):
    command = "%s --ip %s --status" % (stmcconfig, stmc_ip)

    try:
        child = pexpect.spawn(command, timeout=5)
        child.expect('STMC booted successfully')
    except pexpect.EOF, pexpect.TIMEOUT:
        return False
    else:
        return True


def stmc_reset(stmcconfig, stmc_ip, hard_reset_command):
    pexpect.run(hard_reset_command)

    for loop_index in range(1, 5):
        print("   reseting (%d)" % (loop_index))
        if stmc_status_ok(stmcconfig, stmc_ip):
            print('    [Error]')
            return True
        time.sleep(5)
    return False


def stmc_serial_relay(stmcconfig, stmc_ip):
    command = "%s --ip %s --serial-relay" % (stmcconfig, stmc_ip)

    try:
        child = pexpect.spawn(command, timeout=20)
        child.expect("Starting serial relay : ip: %s port: 5331" % (stmc_ip))
    except pexpect.EOF, pexpect.TIMEOUT:
        return False
    else:
        return True


def main():
    if len(sys.argv) < 4:
        print("Usage: %s stmcconfig stmc_ip stmc_hard_reset" % (sys.argv[0]))
        sys.exit(1)

    # Get arguments
    stmcconfig = sys.argv[1]
    stmc_ip = sys.argv[2]
    stmc_hard_reset = sys.argv[3]

    # Check STMC2 status
    print("Checking status (%s)..." % (stmc_ip))
    if not stmc_status_ok(stmcconfig, stmc_ip):
        print('   [Error]')
        print('Reseting the STMC2...')
        if not stmc_reset(stmcconfig, stmc_ip, stmc_hard_reset):
            print('   [Error]')
            sys.exit(1)
    print('   [Ok]')

    print("Setting serial relay (%s)..." % (stmc_ip))
    if not stmc_serial_relay(stmcconfig, stmc_ip):
        print('   [Error]')
        sys.exit(1)
    print('   [Ok]')

    sys.exit(0)


if __name__ == '__main__':
    main()
