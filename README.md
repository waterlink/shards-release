# shards-release

An application written in Crystal to simplify release process for Crystal Shards.

## Installation

```bash
git clone https://github.com/waterlink/shards-release
cd shards-release
crystal build src/release.cr
cp release /path/where/you/want/to/install/it/
```

## Usage

### Patch release

```bash
release
```

### Minor release

```bash
release minor
```

### Major release

```bash
release major
```

## Contributing

1. Fork it ( https://github.com/waterlink/shards-release/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [waterlink](https://github.com/waterlink) Oleksii Fedorov - creator, maintainer
