#! /bin/bash

if ! command -v curl >/dev/null 2>&1; then
	echo "curl must be installed"
	exit 1
fi

curl  -X GET -H "Authorization: token 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" https://raw.githubusercontent.com/Sargates/.zshconfig/testing/install.sh > install.sh
