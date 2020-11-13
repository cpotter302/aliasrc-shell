find "${PWD}"-type f -name '*.sh'

shfmt -i 2 -ci -w ./*.sh &&
  shfmt -i 2 -ci -w setup/*.sh &&
  shfmt -i 2 -ci -w functions/*.sh
