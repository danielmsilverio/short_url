# ShortURL

![Badge em Desenvolvimento](https://img.shields.io/badge/status-em_desenvolvimento-green)

> Este é um projeto de estudos, com a finalidade de demonstrar minha familiaridade com a linguagem elixir e outros pontos de interesse.

ShortURL é uma api para criar um encurtador de urls.

# ⚙️ Funcionalidades do Projeto
- `CRUD usuário`: possível criar/ver/atualizar/deletar dados do usuário
- `Criar encurtador da url`: possível encurtar uma URL, onde é associada ao usuário

# ▶️ Como iniciar o projeto

- Execute `mix setup` para instalar as dependencias
- Para iniciar o serviço, execute `mix phx.server`

Agora é possível executar comandos básicos:

```shell
curl --request POST \
  --url http://localhost:4000/api/users \
  --header 'Content-Type: application/json' \
  --data '{
	"user": {
		"name": "Daniel",
		"email": "daniel@teste.com",
		"password": "teste"
	}
}'
```
resultado esperado:
```json
{
	"data": {
		"id": 1,
		"name": "Daniel",
		"email": "daniel@teste.com"
	}
}
```

# 🧪 Rodando os testes
- Para executar os testes, é necessário apenas rodar `mix test`

# 🛠️ Tecnologias utilizadas

![Elixir](https://img.shields.io/badge/Elixir-4B275F?style=for-the-badge&logo=elixir&logoColor=white)
![Postgres](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Githubactions](https://img.shields.io/badge/Github%20Actions-282a2e?style=for-the-badge&logo=githubactions&logoColor=367cfe)


# 🆙 Melhorias a serem realizados

- [ ] Adicionar autentificação
- [ ] Alterar para rodar em docker
- [ ] Adicionar pipeline CI/CD
- [ ] Ajustar para apróximar de Clean Architecture
