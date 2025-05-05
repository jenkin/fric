# F.R.I.C.

Frontend Resources Integrity Checker (FRIC) is a Proof of Concept to explore challenges and constraints of frontend security related to resources integrity.

## Context

Open source ensures that community can audit source code and prevent threats at dev time.

Many transformations from source code to deployed artifacts occur before that code can run on user device.

This process should be deterministic and reproducible, so final users can check integrity of downloaded artifacts against the expected ones from source code before running them.

This project is inspired by an internal talk about [Subresource Integrity](https://developer.mozilla.org/en-US/docs/Web/Security/Subresource_Integrity) powered by [SparkFabrik](https://github.com/sparkfabrik) and all the [related works the Safe{Wallet} developers have done](https://github.com/safe-global/safe-wallet-monorepo/issues/5154) following the [Bybit hack](https://www.ic3.gov/PSA/2025/PSA250226).

## Usage

1. Clone this repo locally: `git clone https://github.com/jenkin/fric.git`
2. Enter the project root directory: `cd fric/`
3. Activate the dev container (see [containers.dev](https://containers.dev) for futher informations)
4. Build the latest tag: `bash scripts/safe-wallet-monorepo/000-update.sh`
5. Check the local build against the deployed one: `bash scripts/safe-wallet-monorepo/010-check.sh` (only `html` and `js` files)

## Contribution

Contributions are welcome, you can open issues to suggest ideas or share interesting resources.

## License

CC0 - Public Domain.
