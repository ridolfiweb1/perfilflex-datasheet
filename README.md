# PerfilFlex Datasheet

Catalogos HTML da PerfilFlex, com tabelas tecnicas, imagens de perfis,
materiais de referencia e arquivos prontos para impressao.

## Arquivo principal

Use `index.html` como ponto de entrada do projeto.

O arquivo `index.html` redireciona para `novo 8.html`, que hoje e a versao principal do catalogo.

## Estrutura

- `index.html`: entrada recomendada para abrir ou publicar o projeto
- `novo 8.html`: versao principal atual do catalogo
- `novo 7.html`: versao anterior mantida para referencia
- `perfilflexdata01.html`: catalogo Polycord publicado
- `perfilflexdata02.html`: segunda versao do catalogo Polycord
- `Perfil_TPU/`: catalogo TPU em HTML e previews A4 em PDF
- `imagens/`: imagens e diagramas usados no catalogo
- `referencias/`: arquivos de apoio em PDF e Excel
- `scripts/`: geracao dos PDFs e publicacao dos HTMLs
- `PerfilFlex-Policort-Piloto-1-pagina.pdf`: versao em PDF do material

## Geracao de PDF

O script `scripts/export-vetorial-full.sh` gera um PDF vetorial de pagina
unica a partir de um HTML:

```bash
./scripts/export-vetorial-full.sh perfilflexdata02.html saida.pdf
```

Na primeira execucao, o script instala o Playwright em `/tmp/pwpdf`.

## Publicacao local

Os scripts abaixo publicam os HTMLs no diretorio configurado no servidor:

```bash
./scripts/publish-perfilflexdata01.sh
./scripts/publish-perfilflexdata02.sh
```

## Como abrir

Basta abrir `index.html` no navegador.

## Observacoes

- Os nomes atuais dos arquivos HTML foram preservados para evitar quebra de links e do seu fluxo de trabalho.
- Logs locais de autopublicacao e PDFs de teste sao ignorados pelo Git.
