function! db#adapter#firebird#canonicalize(url) abort
  let url = substitute(a:url, '^firebird:/\@!', 'firebird:///', '')
  let parsed = db#url#parse(url)
  return db#url#absorb_params(parsed, {
        \ 'user': 'user',
        \ 'userName': 'user',
        \ 'password': 'password',
        \ 'server': 'host',
        \ 'serverName': 'host',
        \ 'port': 'port',
        \ 'portNumber': 'port'})
endfunction

function! s:server(url) abort
  return get(a:url, 'host', 'localhost') .
        \ (has_key(a:url, 'port') ? '/' . a:url.port : '') .
        \ (has_key(a:url, 'path') ? ':' . a:url.path : '')
endfunction

function! db#adapter#firebird#interactive(url) abort
  let url = db#url#parse(a:url)
  let encrypt = get(url.params, 'encrypt', get(url.params, 'Encrypt', ''))
  "return (has_key(url, 'password') ? ['env', 'ISC_PASSWORD=' . url.password] : []) +
  "      \ (has_key(url, 'user') ? ['ISC_USER=' . url.user] : []) +
        return ['isql', '-m'] +
        "\ (empty(encrypt) ? [] : ['-N'] + (encrypt ==# '1' ? [] : [url.params.encrypt])) +
        "\ s:boolean_param_flag(url, 'trustServerCertificate', '-C') +
        "\ (has_key(url.params, 'authentication') ? ['--authentication-method', url.params.authentication] : []) +
        "\ db#url#as_argv(url, '', '', '', '-u ', '-p ', '') +
        \ ['-p', url.password] +
        \ ['-u', url.user] +
        \ [s:server(url)]
endfunction

"function! db#adapter#firebird#input(url, in) abort
"  return db#adapter#firebird#interactive(a:url) + ['-i', a:in]
"endfunction

"function! s:complete(url, query) abort
"  let cmd = db#adapter#firebird#interactive(a:url)
"  let query = 'SET NOCOUNT ON; ' . a:query
"  let out = db#systemlist(cmd + ['-h-1', '-W', '-Q', query])
"  return map(out, 'matchstr(v:val, "\\S\\+")')
"endfunction
"
"function! db#adapter#firebird#tables(url) abort
"  return s:complete(a:url, 'SELECT RDB$RELATION_NAME FROM RDB$RELATIONS WHERE RDB$VIEW_BLR IS NULL AND (RDB$SYSTEM_FLAG IS NULL OR RDB$SYSTEM_FLAG = 0)');
"endfunction
