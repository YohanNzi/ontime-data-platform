import logging

from airflow.providers.telegram.hooks.telegram import TelegramHook
from airflow.sdk import Context

logger = logging.getLogger(__name__)


def _truncate(value: object, limit: int) -> str:
    text = str(value)
    return text if len(text) <= limit else text[: limit - 3] + "..."


def alert_on_failure(context: Context) -> None:
    """Journalise l'échec définitif et envoie une alerte Telegram."""
    ti = context["task_instance"]
    exc = context.get("exception")
    error = (
        f"{type(exc).__name__}: {exc}"
        if exc is not None
        else "Exception non disponible"
    )

    logger.error(
        "Échec Airflow | dag=%s | task=%s | run=%s | essai=%s | erreur=%s",
        ti.dag_id,
        ti.task_id,
        ti.run_id,
        ti.try_number,
        error,
    )

    message = (
        "Échec définitif Airflow\n"
        f"DAG : {_truncate(ti.dag_id, 250)}\n"
        f"Tâche : {_truncate(ti.task_id, 250)}\n"
        f"Run : {_truncate(ti.run_id, 400)}\n"
        f"Essai : {ti.try_number}\n\n"
        f"Erreur : {_truncate(error, 800)}"
    )

    try:
        TelegramHook().send_message(
            {
                "text": message,
                "parse_mode": None,
            }
        )
    except Exception:
        logger.exception(
            "Échec de l'envoi Telegram | dag=%s | task=%s | run=%s",
            ti.dag_id,
            ti.task_id,
            ti.run_id,
        )
