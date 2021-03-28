import nl.epij.gcp.gcf.ClojureBackgroundFunction;

public class TelegramBot extends ClojureBackgroundFunction {
    @Override
    public String getHandler() {
        return "telegram-bot.core/app";
    }
}
