__TYNIO_NAKED_DOMAIN__ {
  proxy / localhost:__TYNIO_PORT__ {
    transparent
  }
  tls chilts@appsattic.com
  log stdout
  errors stderr
}

www.__TYNIO_NAKED_DOMAIN__ {
  redir http://__TYNIO_NAKED_DOMAIN__{uri} 302
}
