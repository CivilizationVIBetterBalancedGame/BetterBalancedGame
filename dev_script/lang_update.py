from sys import argv
import re

ENGLISH_PATH = '../lang/english.xml'
ENGLISH_TAG = 'en_US'

FILES = {'../lang/chinese.xml': 'zh_Hans_CN',
         '../lang/french.xml': 'fr_FR',
         '../lang/german.xml': 'de_DE',
         '../lang/japanese.xml': 'ja_JP',
         '../lang/korean.xml': 'ko_KR',
         '../lang/polish.xml': 'pl_PL',
         '../lang/portuguese.xml': 'pt_BR',
         '../lang/russian.xml': 'ru_RU',}

def write_file(tag, text, file, lang_tag):
    print(f"Process file {file}")
    with open(file, 'r', encoding='utf-8') as fd:
        txt = fd.read()
    f = re.findall(rf"""<Replace\s*Tag=\"{tag}\"\s*Language=\"[a-zA-Z_]+\">\s*<Text>(.*?)<\/Text>\s*<\/Replace>""", txt)
    assert len(f) < 2
    if f:
        txt = re.sub(
                rf"""\s*<Replace\s*Tag=\"{tag}\"\s*Language=\"[a-zA-Z_]+\">\s*<Text>.*?<\/Text>\s*<\/Replace>""",
                f"\n\t\t<Replace Tag=\"{tag}\" Language=\"{lang_tag}\">\n\t\t\t<Text>{text}</Text>\n\t\t</Replace>",
                txt,
        )
    else:
        txt = re.sub(
                rf"""\s*</LocalizedText>""",
                f"\n\t\t<Replace Tag=\"{tag}\" Language=\"{lang_tag}\">\n\t\t\t<Text>{text}</Text>\n\t\t</Replace>\n\t</LocalizedText>",
                txt,
        )
    print(f"Write file {file}")
    with open(file, 'w', encoding='utf-8') as fd:
        fd.write(txt)


def main():
    if len(argv) != 3:
        print(f"USAGE: {argv[0]} [Tag] [Text]")
        return
    tag = argv[1]
    text = argv[2]
    write_file(tag, text, ENGLISH_PATH, ENGLISH_TAG)
    for k, v in FILES.items():
        write_file(tag, "[COLOR_RED]TO_TRANSLATE: " + text, k, v)



if __name__ == '__main__':
    main()