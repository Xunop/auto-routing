#!/usr/bin/expect

set username "your-username"
set password "your-password"

spawn gpclient --fix-openssl connect --default-browser vpn.example.com

expect {
    "Username:" {
        send "$username\r"
    }
    timeout {
        puts "Timeout waiting for username prompt"
        exit 1
    }
}

expect {
    "Password:" {
        send "$password\r"
    }
    timeout {
        puts "Timeout waiting for password prompt"
        exit 1
    }
}

expect {
    "Username:" {
        send "$username\r"
    }
    timeout {
        puts "Timeout waiting for username prompt"
        exit 1
    }
}

expect {
    "Password:" {
        send "$password\r"
    }
    timeout {
        puts "Timeout waiting for password prompt"
        exit 1
    }
}

interact
