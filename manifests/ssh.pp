file { '/root/.ssh':
  ensure => directory,
  owner  => 'root',
  group  => 'root',
  mode   => '0700',
}

node 'dc1.samba4.local' {
  file { '/root/.ssh/id_rsa':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => '-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAs+n1IwpUHARQ7eMhvODlhI0N2VuVMLTVxQGQgtq/DtEEFONU
j4dVqZTFNEFRINUsYXIEBnhyKOTy+VQedWoFUKPZAZHvR4vKpZ+KUzuf7aqvFORn
KUOA1Ad5rzBJS7o5hBhh6WXKQJEYMHCIeDZ56aPCo5y9vmA+AsvcSDscZ8hpWGgN
A/u0IPU9gHmOmPi4vPbuDziu2wGpBdUCOa0GiPB4ba2gcJYJNfcF0chsNhZayD7W
6Luwa8YXfVvZpieXiQyUmiHyjwxmnIzLXUNE35kf2kIMJc/+9erMZMNCuAzvrAcx
rnaXYBPIMRpmXvsVbtAvAqW5JbsPCiIiKD1zNwIDAQABAoIBAGh/PfuBN0MimqLh
Jqpe8dBgYSfbErc8gWEwvG/Uf94qNrWvKGFJGM8rcrMcMPPh/SoIICBl+uCXwixg
2GQYFUg2Moe/7HvgzO4P0Tbwzb4sQg7fbq+/3mbIhLvlTt0mJ9v6kXwPvD5uR99y
rUEtWvgCPr3q/yZBHiNfpu1pL+Fyw5oXD87uP4f1cMqsHuIS013zHYov/ipXW1Qm
rLH+nJbokIa4YqJVoVHlArE1EntRSd2kpi636yHK7vYUCjCmHy9RAt6izdXyw9al
ftNQEOUmmutJDw/TvkLE+jSr51yg7rYAONI1ppY5S/wIS9OAN5HmnhAu4oH0DxXX
ATS+ynECgYEA3ToRaoROxWyHUDY6QsBk6fmkOwfijV8o1NSolEJ3NjYV9tg0cBe5
r7jAtl6WS6MZaOi7kd3bfH+dtWlMTtGMcQfgnLEgCWhu3d7ib+phiRPRtm5AlI8u
cILOW3Dy3gFwp2Zwils4hvQoSPhSjPznqtiItLF+3uolgsg2YZPRsn8CgYEA0DGA
TIWlsWADXZh/RUtSAQXfrebjzDRJL0GoRxa1qk1DhPi2jGfKCe56YxKzxg/b5TCH
ip0XN5OH4nOYGTb4AGVXSrHa67i53NoXWgLFZ7G3A9Rlhj5h67MifMqWRB5mkJOO
SCG/XDJg8mXRgD8w9BzYYdaOUTEOIggONLN980kCgYEApdfkOn/ZNXM4tU8RufzV
Kfn1vjMZCXYu++44OnzhNYiySoymMun2T98myRB7h1RLtjPSeXViFyDsL5UymVvJ
9uo63fyC0cqyYi22fsOsPsDW0/Yu/6+e1sWYwUAZMYjO1Q+cinv8El9y29EcwYjO
e2s8gIkXXTEW0cYZzmisKS0CgYADBwU/l53uM2A5JzOKlWrO2wACrl3XpVb/GexR
hFIF9POrZlZ5OjUk6dPbxvTYR3jCH2+JI3mn9DxAnb+zdiorD04ypt1xGhGR1ZYL
WAj41gu8QYVsa1HPNJ6mw+dlfC+voIWsJNl8hLsGK1bdj42trxGycoVFRvpWolla
iNWnCQKBgGGcNteIoM8J68t1dz8NSH+pWFgteBaSAGZalAPLFGGuzlteXakSB1XJ
X0a25zwEAQ7vzTNPsL9GC0dsWZE/KNjR5WNK1/v9q+WdZjsrhFjSENpb+s8LIBEz
ZLFfMJXPnYQHuavpKVB6NMGT0ar1Gp0nHLHG9Jp6eqDyykpxPW3d
-----END RSA PRIVATE KEY-----
',
  }

  file { '/root/.ssh/id_rsa.pub':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCz6fUjClQcBFDt4yG84OWEjQ3ZW5UwtNXFAZCC2r8O0QQU41SPh1WplMU0QVEg1SxhcgQGeHIo5PL5VB51agVQo9kBke9Hi8qln4pTO5/tqq8U5GcpQ4DUB3mvMElLujmEGGHpZcpAkRgwcIh4Nnnpo8KjnL2+YD4Cy9xIOxxnyGlYaA0D+7Qg9T2AeY6Y+Li89u4POK7bAakF1QI5rQaI8HhtraBwlgk19wXRyGw2FlrIPtbou7Brxhd9W9mmJ5eJDJSaIfKPDGacjMtdQ0TfmR/aQgwlz/716sxkw0K4DO+sBzGudpdgE8gxGmZe+xVu0C8Cpbkluw8KIiIoPXM3 root@dc1.samba4.local
',
  }

  ssh_authorized_key { 'root@dc2.samba4.local':
    ensure => present,
    user   => 'root',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCfbufhGRIJTyAIAVrVPj8wPA9NGSK9onef7GT0AF60DqGfqSckPxOoewFKIHtgjtKU/MT1r8VHh6qq3FcU4GyBrEJJtWsfnndohEWLihL0+BtqC/ksgxWjq4RCfzZcwohOHglZKBZ7YkUhCc62r3ehWKHMjtZJGdexjD2HOQU50yV9E0ARffOdr1RvmuO5tqUKBOCBJTwuKBXdzuG+8RXyZspOYy1qMm+KpmexlfWC9kPNiTIdRzbWKkQCvqsNiewcOP7tl2Z2SsAjk0Z59vFsMMJTkY5FtgtdAmvulmRu3fLLPmPk1v9iAoB+FuFHu6TAXuO1OKe3qJq9RHLyTg9V',
    options => [
      # No reverse DNS at this point.
      #'from="dc2.samba4.local"',
      'command="/usr/bin/rsync ${SSH_ORIGINAL_COMMAND#* }"',
      'no-port-forwarding',
      'no-X11-forwarding',
      'no-agent-forwarding',
      'no-pty',
    ],
  }
}


node 'dc2.samba4.local' {
  file { '/root/.ssh/id_rsa':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => '-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAn27n4RkSCU8gCAFa1T4/MDwPTRkivaJ3n+xk9ABetA6hn6kn
JD8TqHsBSiB7YI7SlPzE9a/FR4eqqtxXFOBsgaxCSbVrH553aIRFi4oS9Pgbagv5
LIMVo6uEQn82XMKITh4JWSgWe2JFIQnOtq93oVihzI7WSRnXsYw9hzkFOdMlfRNA
EX3zna9Ub5rjubalCgTggSU8LigV3c7hvvEV8mbKTmMtajJviqZnsZX1gvZDzYky
HUc21ipEAr6rDYnsHDj+7ZdmdkrAI5NGefbxbDDCU5GORbYLXQJr7pZkbt3yyz5j
5Nb/YgKAfhbhR7ukwF7jtTint6iavURy8k4PVQIDAQABAoIBAFvdSZq4GV5nyysR
rMbmQP6H/MEN1Kiz7n2ldl3pwKe7LoGSs8z801Tm201c/fobEVdrdgmip+eZUkt0
/nA3CA6HtQJHmFv1sRP18yR+AIJKW3F1SLPPLC7Maz7tkeNM68EnKXfH03xwmSh6
QDOfUy0Sptf5DZu9Wj0hc2pw/oPcLwxN+M/RlFrUKAOEno9mk1W6zBfSvMHHWaJ9
w9tQ9K1fkF1u1rDU2+4cQ2/cFviKfT5Lmo/ujaOSlvpfsDxTfHOeQn4AH8eU0CLt
Y0XsfXusGrtKAWe8T1LT2x8vNlc9osLrqqMGcr6pVqxXGj0PQrB1Ngp5CaHCH8iU
rtDln0ECgYEAzPlVdJIm+7PeNFR9GNPMsXNNV2HPiCU3O59l8N9ZOEe+HHNcodPb
/KM0MYkRMJmzWe99WDxMW1R01kq3VRc++enONmdYCVifhbRoiCjy6mxPgCSrPV8/
H0y8tcMO3MKF7UdgLFSUA+FcpQvJSRsUS2GcT0ptgozjTS2hWDVu210CgYEAxx9V
QCFEeSotFnRT5BAPU93G1LiRiJACy2Xv9INqlId/82sCgQOHNsdWiqCmrHJ6ZZWV
V9Pt0SWk7I2V8Ojim3twXmLJn0+dX485BO8xJ4aIgEydeXgnVulFD6ZXSquEVL9x
D0ou9TseaUkEx+LUnAM6A50IzxrvmGnRqzUiPFkCgYB86Q0cptw+01P8S+iYMqox
EXT2ZVLVQuiv2umCqnlyhLXkHKE8tSEAimyKK19gYKodioa2OLjHh2ZUGOA0aKAm
KEdUfBH4UBuWnWR+ZYXzOeIQ00fPdLXA20C8+4uZGKoI+VAwc7Jn0vRkWBRoCqqJ
bYiWAWNPBZCXPdFvMdDGuQKBgE6VRwewGV3YD0M1VYZD8Eig1b9Nt+G1M+UhrblJ
w94qO4zNRoez5MDxmm3LSPv1kehVSEMJGGnZ+WSB3BLfVc8WwBn/0qJUwT7dPxt7
amK27Vf05JDzolLibKbodrq5RdhMVUo7dJzDYBUdBA3+rvmDLHoQl1Fkx/nWiTCQ
H5rBAoGBALOwY5q71H45LBGJz+9I1Yki+f10d0LxBeKH952kaQFrp/iXoPUyYxIs
smE9xaAekO5Pll8dsKunaq3n2qmDkR51qJY5r8xU7zx/F1fbOqpf70zhxdVkbeIo
M5h42djglM8trPMUH3YQCAEzKBtbBwNiTbAAwo6SVTXJ/OQr/5i0
-----END RSA PRIVATE KEY-----
',
  }

  file { '/root/.ssh/id_rsa.pub':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfbufhGRIJTyAIAVrVPj8wPA9NGSK9onef7GT0AF60DqGfqSckPxOoewFKIHtgjtKU/MT1r8VHh6qq3FcU4GyBrEJJtWsfnndohEWLihL0+BtqC/ksgxWjq4RCfzZcwohOHglZKBZ7YkUhCc62r3ehWKHMjtZJGdexjD2HOQU50yV9E0ARffOdr1RvmuO5tqUKBOCBJTwuKBXdzuG+8RXyZspOYy1qMm+KpmexlfWC9kPNiTIdRzbWKkQCvqsNiewcOP7tl2Z2SsAjk0Z59vFsMMJTkY5FtgtdAmvulmRu3fLLPmPk1v9iAoB+FuFHu6TAXuO1OKe3qJq9RHLyTg9V root@dc2.samba4.local
',
  }

  ssh_authorized_key { 'root@dc1.samba4.local':
    ensure  => present,
    user    => 'root',
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCz6fUjClQcBFDt4yG84OWEjQ3ZW5UwtNXFAZCC2r8O0QQU41SPh1WplMU0QVEg1SxhcgQGeHIo5PL5VB51agVQo9kBke9Hi8qln4pTO5/tqq8U5GcpQ4DUB3mvMElLujmEGGHpZcpAkRgwcIh4Nnnpo8KjnL2+YD4Cy9xIOxxnyGlYaA0D+7Qg9T2AeY6Y+Li89u4POK7bAakF1QI5rQaI8HhtraBwlgk19wXRyGw2FlrIPtbou7Brxhd9W9mmJ5eJDJSaIfKPDGacjMtdQ0TfmR/aQgwlz/716sxkw0K4DO+sBzGudpdgE8gxGmZe+xVu0C8Cpbkluw8KIiIoPXM3',
    options => [
      # No reverse DNS at this point.
      #'from="dc1.samba4.local"',
      'command="/usr/bin/rsync ${SSH_ORIGINAL_COMMAND#* }"',
      'no-port-forwarding',
      'no-X11-forwarding',
      'no-agent-forwarding',
      'no-pty',
    ],
  }
}
