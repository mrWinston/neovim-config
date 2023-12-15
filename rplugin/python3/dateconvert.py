import pynvim
import dateparser


@pynvim.plugin
class TestPlugin(object):
    def __init__(self, nvim: pynvim.api.Nvim):
        self.nvim = nvim

    @pynvim.command("ParseDate", nargs="*", range="")
    def parsedate(self, args, range):
        _, startLine, startCol, _ = self.nvim.funcs.getpos("'<")
        _, endLine, endCol, _ = self.nvim.funcs.getpos("'>")

        if startLine != endLine:
            self.nvim.command("echo 'I refuse to do that over multiple lines'")
            return

        text = self.nvim.current.line[startCol - 1:endCol]
        date = dateparser.parse(text)

        if not date:
            self.nvim.command("echo 'couldnt parse that'")
            return

        datestring = f"{date.year}-{date.month}-{date.day}"
        newline = (
            self.nvim.current.line[0:startCol - 1]
            + datestring
            + self.nvim.current.line[endCol:]
        )
        self.nvim.current.line = newline
        return datestring
