GRIN multi-wallet scripts
=========================

This is a set of scripts that can be used to transfer a number of
GRINs from one main wallet to a configurable number of smaller
wallets.

These scripts use tcl and expect, so install it with ``apt install
expect``. They expect ``grin-wallet`` to be in the PATH.


Included scripts
----------------

1. generate_wallets.sh
^^^^^^^^^^^^^^^^^^^^^^

Edit the script and set ``numwallets`` and ``walletprefix`` to your
liking. Running the script generates several folders in the current
directory, one for each wallet generated. It outputs the names of the
wallets created (e.g. ``my_1``, ``my_2``, etc.) together with their
24-word seed phrase.

Caution: the created wallets are _not_ password protected. You should
destroy them immediately after calling the third script (receive_txs)
and keep the seed phrases in a secure place.


2. create_txs.sh
^^^^^^^^^^^^^^^^
Your main wallet (containing the funds to split/send to the previously
generated wallets) needs to be in the same directory as the generated
wallets and this script. Set ``senderwallet`` and ``senderpassword``
accordingly. ``amount`` is the amount to send to each wallet in GRIN
(i.e. not multiplied by 1e9) and ``numwallets`` and ``walletprefix``
should match your previous settings.

This script first sends 0.1 GRIN to itself and creates ``numwallets +
1`` change outputs. This means that after waiting ~10 minutes so the
tx-to-self got confirmed, the remaining ``numwallets`` transaction can
all happen at once.

After running this script you'll have a ``.tx`` file for each wallet
(e.g. ``my_1.tx``, ``my_2.tx``, etc.)


3. receive_txs.sh
^^^^^^^^^^^^^^^^^
This scripts looks for all ``.tx`` files in the current directory, and
if it finds a matching wallet imports (``receive`` in grin
terminology) it. The output is a ``.tx.response`` file for each
transaction.


4. finalize_txs.sh
^^^^^^^^^^^^^^^^^^
Set ``senderwallet`` and ``senderpassword`` like in step 2. This
script looks for all ``.tx.response`` files in the current directory
and finalizes the transactions from the main wallet.


FAQ
---

Why?
^^^^
When you sell coins in Germany, you don't pay any taxes on the sale
(and profit) if you've held the coins for at least a year. Given that
transactions in grin are private and just the utxo set is stored, this
might be hard to prove. With this script, you can create several "GRIN
stashes", then wait a year, and have a single utxo from a year ago if
you recover the wallet via its seed.

There are probably other use cases as well, e.g. gifting a bunch GRIN,
or creating physical GRIN-coins :-)


Why tcl?
^^^^^^^^
``expect`` is a great tool for scripting interactive command line
tools (go check it out); also I've fallen in love with tcl while using
EDA tools like Cadence.


Why the .sh extension?!
^^^^^^^^^^^^^^^^^^^^^^^
It's ``.sh`` to indicate it should be run from a terminal... I know
¯\\_(ツ)_/¯
