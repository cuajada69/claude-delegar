<div align="center">

# ¿Por qué pagar Opus para buscar archivos?

**claude-delegar hace que Claude Code mande el trabajo pesado y mecánico a Haiku y Sonnet, y se quede con lo que de verdad necesita cerebro.**
Sin que se lo pidas en cada prompt. Dos agentes, una regla, un comando.

<a href="#licencia"><img src="https://img.shields.io/badge/licencia-MIT-green?style=flat-square" alt="Licencia MIT"></a>
<img src="https://img.shields.io/badge/para-Claude_Code-D97757?style=flat-square" alt="Claude Code">
<img src="https://img.shields.io/badge/instalación-1_comando-orange?style=flat-square" alt="1 comando">
<img src="https://img.shields.io/badge/dependencias-0-blue?style=flat-square" alt="0 dependencias">

<table>
<tr>
<td align="center" width="33%"><h3>40× más barato</h3>leer con Haiku 5.5 que con Opus 5.5<br><sub>$0.10 vs $4.00 por millón de tokens de entrada</sub></td>
<td align="center" width="33%"><h3>2× más barato</h3>programar con Sonnet 5.5 que con Opus 5.5<br><sub>$2 / $10 vs $4 / $20 por millón</sub></td>
<td align="center" width="33%"><h3>$1.20 → $0.03</h3>leer 300K tokens de archivos<br><sub><a href="#cuentas-claras">ejemplo calculado</a>, no medido</sub></td>
</tr>
</table>

**[Instalar](#instalar) · [Cómo funciona](#cómo-funciona) · [Cuentas claras](#cuentas-claras) · [Cuándo no ayuda](#cuándo-no-ayuda) · [Desinstalar](#desinstalar)**

</div>

---

<table>
<tr>
<th width="50%">Claude Code normal</th>
<th width="50%">Con claude-delegar</th>
</tr>
<tr>
<td valign="top">

> "Busca dónde se valida el correo en todo el proyecto."

Opus abre 40 archivos, se los lee todos con tarifa de Opus y llena tu contexto con código que no vas a volver a mirar.

</td>
<td valign="top">

> "Busca dónde se valida el correo en todo el proyecto."

Opus le pasa la búsqueda a **Haiku**. Haiku lee los 40 archivos y devuelve 5 líneas con rutas. Opus revisa el resultado y sigue con lo tuyo.

</td>
</tr>
</table>

**Misma respuesta. La lectura pesada la paga el modelo barato y tu conversación queda limpia.**

## Instalar

**Mac / Linux / Git Bash**

```bash
curl -fsSL https://raw.githubusercontent.com/cuajada69/claude-delegar/main/install.sh | bash
```

**Windows (PowerShell)**

```powershell
irm https://raw.githubusercontent.com/cuajada69/claude-delegar/main/install.ps1 | iex
```

Abre una sesión nueva de Claude Code y escribe `/agents`. Tienen que aparecer `buscador-rapido` e `implementador`. Y ya, no hay nada más que configurar.

<sub>El instalador copia 2 archivos a <code>~/.claude/agents/</code> y agrega un bloque marcado a <code>~/.claude/CLAUDE.md</code>, sin tocar lo que ya tengas ahí. Si ya tenías un agente con el mismo nombre, lo guarda como <code>.bak</code>. Puedes correrlo varias veces sin que se dupliquen cosas. ¿Prefieres ver el código antes de ejecutarlo? Clona el repo y corre <code>./install.sh</code> o <code>.\install.ps1</code>.</sub>

## Cómo funciona

Son tres piezas, todas texto plano que puedes leer en dos minutos.

| Pieza | Modelo | Qué hace |
|---|---|---|
| [`buscador-rapido`](agents/buscador-rapido.md) | **Haiku** | Busca en muchas carpetas, lee y resume documentos, hace inventarios, renombra en lote. Devuelve rutas y hallazgos concretos, no opiniones |
| [`implementador`](agents/implementador.md) | **Sonnet** | Código que ya tiene especificación clara y un criterio de "listo": funciones, tests, el mismo cambio en varios archivos. Corre las pruebas y te dice la salida real |
| [La regla](regla-claude-md.md) en `CLAUDE.md` | (tu modelo principal) | Le dice a Claude **cuándo** delegar sin que se lo pidas, y qué se queda haciendo él |

¿Por qué no una skill? Porque una skill solo se carga cuando la tarea coincide con su descripción, y delegar aplica a casi todo. `CLAUDE.md` se lee en todas las sesiones, así que la regla siempre está activa.

**Las reglas que sigue Claude:**

- **Delegar solo cuando vale la pena.** Si algo se resuelve en 2 o 3 pasos, lo hace él directamente. Un subagente arranca sin contexto, y para tareas cortas eso sale más caro.
- **Máximo 2 agentes a la vez**, para que no se te vaya la cuota en ráfagas.
- **El diseño, las decisiones y la revisión final no se delegan.** Claude revisa lo que le devuelven antes de dártelo por bueno.
- **Los agentes no hacen commits, push, compras ni nada que tenga costo**, y no borran archivos salvo que la tarea lo pida explícitamente.

## Cuentas claras

Estos son los precios de la API de Anthropic por millón de tokens (octubre 2026):

| Modelo | Entrada | Salida | vs Opus 5.5 |
|---|---:|---:|---:|
| Opus 5.5 | $4.00 | $20.00 | 1× |
| Sonnet 5.5 | $2.00 | $10.00 | **2× más barato** |
| Haiku 5.5 | $0.10 | $0.50 | **40× más barato** |

<sub>Haiku 5.5 cuesta eso con prompts de hasta 100K tokens; por encima sube a $0.50 / $2.50. Los precios oficiales y actualizados están en la <a href="https://www.anthropic.com/pricing">página de precios</a>.</sub>

**Ejemplo calculado (no medido).** Le pides a Claude que encuentre algo y para eso hay que leer unos 300K tokens de archivos:

| | Quién lee | Costo de leer | Lo que llega a tu conversación |
|---|---|---:|---|
| Sin delegar | Opus | 300K × $4/M = **$1.20** | Los 300K tokens |
| Con claude-delegar | Haiku | 300K × $0.10/M = **$0.03** | Un resumen de ~2K tokens |

Además hay un segundo ahorro que no aparece en la factura: tu conversación principal no se llena de archivos. Eso significa menos compactaciones y que el modelo se acuerde mejor de lo que estaban haciendo.

**¿Tienes Pro o Max?** Ahí no pagas por token, pero tus límites de uso se gastan más lento con los modelos pequeños. Delegar te deja trabajar más rato antes de llegar al tope.

## Cuándo no ayuda

Lo decimos claro para que nadie se lleve una sorpresa:

- **Para tareas cortas.** El subagente necesita que le expliquen la tarea y luego hay que leer su resumen. Si la tarea son 2 o 3 pasos, sale más caro delegar, y por eso la regla le dice a Claude que no lo haga.
- **Si Haiku se equivoca, Claude tiene que rehacer el trabajo.** La regla le exige revisar lo que le devuelven, pero esa revisión también gasta tokens.
- **Si pagas por petición y no por token**, el precio por token no te cambia nada.
- **Todavía no hay un benchmark propio.** Los números de arriba salen de los precios publicados, no de medir sesiones reales. Si mides tu uso antes y después, abre un issue con los datos y los agregamos aquí, aunque salgan malos.

## Personalizar

Los agentes son archivos Markdown en `~/.claude/agents/`. Puedes editar la descripción para cambiar cuándo se usan, cambiar `model:` o crear agentes nuevos copiando uno. La regla está entre las marcas `<!-- claude-delegar:start -->` y `<!-- claude-delegar:end -->` de tu `CLAUDE.md`. Ojo: si vuelves a correr el instalador, ese bloque se reemplaza por la versión del repo.

## Desinstalar

Borra los dos agentes y el bloque marcado:

```bash
rm ~/.claude/agents/buscador-rapido.md ~/.claude/agents/implementador.md
# luego abre ~/.claude/CLAUDE.md y borra desde <!-- claude-delegar:start --> hasta <!-- claude-delegar:end -->
```

## Licencia

MIT. Úsalo, cámbialo, compártelo.
