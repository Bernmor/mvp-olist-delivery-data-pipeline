"""Verificações locais das regras SQL com exemplos pequenos e calculados à mão."""

import sqlite3
import unittest
from pathlib import Path


RAIZ = Path(__file__).resolve().parents[1]


def consulta(nome, **tabelas):
    caminho = RAIZ / "sql" / nome
    assert caminho.exists(), f"Consulta obrigatória ausente: {nome}"
    return caminho.read_text(encoding="utf-8").format(**tabelas)


class RegrasDeEntrega(unittest.TestCase):
    def test_mesmo_dia_eh_pontual_e_ausencia_nao_recebe_resultado(self):
        conexao = sqlite3.connect(":memory:")
        conexao.execute(
            "CREATE TABLE pedidos (order_id TEXT, order_status TEXT, "
            "order_delivered_customer_date TEXT, order_estimated_delivery_date TEXT)"
        )
        conexao.executemany(
            "INSERT INTO pedidos VALUES (?, ?, ?, ?)",
            [
                ("a", "delivered", "2018-01-10 23:59:00", "2018-01-10 08:00:00"),
                ("b", "delivered", "2018-01-11 00:01:00", "2018-01-10 23:59:00"),
                ("c", "shipped", None, "2018-01-10 00:00:00"),
                ("d", "delivered", "2018-01-10 00:00:00", None),
            ],
        )
        linhas = conexao.execute(consulta("indicadores_entrega.sql", pedidos="pedidos")).fetchall()
        self.assertEqual(
            [(linha[0], linha[-2], linha[-1]) for linha in linhas],
            [("a", 1, 0), ("b", 1, 1), ("c", 0, None), ("d", 0, None)],
        )

    def test_consultas_preservam_denominador_e_ausencia_de_frete(self):
        conexao = sqlite3.connect(":memory:")
        conexao.executescript(
            """
            CREATE TABLE fato (order_id TEXT, chave_localidade TEXT, data_compra TEXT,
                pedido_entregue_com_datas INTEGER, entrega_atrasada INTEGER,
                frete_total REAL);
            CREATE TABLE localidade (chave_localidade TEXT, estado TEXT);
            CREATE TABLE datas (data_compra TEXT, ano_mes TEXT);
            INSERT INTO localidade VALUES ('sp','SP'), ('rj','RJ');
            INSERT INTO datas VALUES ('2018-01-01','2018-01'), ('2018-02-01','2018-02');
            INSERT INTO fato VALUES
                ('a','sp','2018-01-01',1,0,10),
                ('b','sp','2018-01-01',1,1,20),
                ('c','rj','2018-02-01',1,1,NULL),
                ('d','rj','2018-02-01',0,NULL,30);
            """
        )
        uf = conexao.execute(
            consulta("atraso_por_uf.sql", fato="fato", localidade="localidade")
        ).fetchall()
        self.assertEqual({r[0]: (r[2], r[3], r[4]) for r in uf},
                         {"SP": (2, 1, 50.0), "RJ": (1, 1, 100.0)})
        mensal = conexao.execute(
            consulta("atraso_por_mes.sql", fato="fato", datas="datas")
        ).fetchall()
        self.assertEqual({r[0]: (r[1], r[2], r[3]) for r in mensal},
                         {"2018-01": (2, 2, 1), "2018-02": (2, 1, 1)})
        frete = conexao.execute(consulta("atraso_por_frete.sql", fato="fato")).fetchall()
        self.assertEqual(sum(r[1] for r in frete), 3)
        self.assertEqual(sum(r[2] for r in frete), 2)
        self.assertIn("Frete ausente", [r[0] for r in frete])


if __name__ == "__main__":
    unittest.main()
