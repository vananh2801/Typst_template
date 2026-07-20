// ============================================================
//  HƯỚNG DẪN SỬ DỤNG GÓI ex_test (dựa trên lib.typ / ex_test.typ)
//  File này biên dịch được độc lập, dùng để tra cứu + xem ví dụ
//  trực quan cho từng lệnh của gói.
// ============================================================

#import "style/lib.typ": *

#show: appearance
#show: tableofcontens

#show raw.where(block: true): it => {
  set text(font: "JetBrains Mono", features: (calt: 0))
  block(stroke: 1pt + red.darken(20%), fill: yellow.lighten(80%), radius: 3pt, inset: 8pt, width: 100%)[
    #it
  ]
}
#show raw.where(block: false): it => {
  set text(font: "JetBrains Mono", features: (calt: 0))
  box(stroke: none, fill: yellow.lighten(80%), radius: 5pt, inset: 4pt, width: auto)[
    #it
  ]
}

// Có thể bật/tắt hiển thị lời giải cho từng loại theorem
#state("vd_show_ans").update(true)
#state("bt_show_ans").update(true)
#state("ex_show_ans").update(true)
#state("btrl_show_ans").update(true)
#state("minhhoa_show_ans").update(true)


#align(center)[
  #v(1fr)
  #text(size: 24pt, weight: "bold")[HƯỚNG DẪN SỬ DỤNG GÓI `ex_test`]
  #v(1fr)
  #text(style: "italic", size: 12pt)[
    Tài liệu dùng cho mã nguồn `ex_test.typ`.\
    Phiên bản gói: #ex_test_version — Tác giả: #ex_test_author\
    Github: #ex_test_github
  ]
  #v(2fr)
]

#heading("Lời cảm ơn", depth: 1, numbering: none)

#ex_test_loicamon

#outline(depth: 2)

#chapter[Giới thiệu]

#section[`project` -- cấu trúc thư mục kiến nghị]

Dự án mẫu có cấu trúc như sau:

```
  project/
  ├── main.typ
  ├── style/
  │   ├── ex_test.typ
  │   └── lib.typ
  ├── data/
  │   └── 9D1-1.typ
  └── imgs/
```

Trong đó:
- `main.typ` là file chính của dự án dùng để khai báo `#import` và `#include`.
- `ex_test.typ` là phần cốt lõi của `ex_test`, định nghĩa cách một "theorem" (định nghĩa/ví dụ/bài tập...) hoạt động, cách trắc nghiệm lưu — xuất đáp án, cách danh sách tự chia cột, cách hình minh hoạ ghép với văn bản... \
  Thầy cô muốn có thể sửa để thay đổi theo nhu cầu của thầy cô, nhưng thường thì không cần thay đổi.
- `lib.typ` file dùng để cấu hình trang giấy, heading, footer,... Thầy cô có thể thay đổi theo sở thích cá nhân. Ngoài ra, trong file này còn có các khai báo như tạo theorem, cách các theorem hiển thị.

- File `9D1-1.typ` là file dữ liệu thể hiện cách mà các theorem đã khai báo được sử dụng.

*Lưu ý:* các lệnh của `ex_test` dùng trong file dữ liệu hầu như có tham số là tiếng Việt, còn các lệnh dùng để khai báo hầu như có tham số là tiếng Anh. Mục đích là giúp tránh nhầm lẫn trong quá trình soạn thảo và quá trình bảo trì gói `ex_test`.

#section[`main.typ` -- khởi tạo file chính]

Ở đầu các file đuôi `.typ`, thầy cô cần khai báo:

```typ
#import "style/ex_test.typ"
```

Thật ra, nếu thầy cô xem kĩ các file mẫu sẽ thấy được rằng nếu trong `lib.typ` mà đã có dòng lệnh này thì khi thầy cô chạy lệnh `#import "style/lib.typ"` ở đầu các file thì đã đi kèm `ex_test` rồi.

#section[`heading` -- các cấp tiêu đề]

Gói `ex_test.typ` định nghĩa lại các cấp tiêu đề LaTeX quen thuộc như:

#align(center)[
  #table(
    columns: (auto, auto),
    stroke: 0.5pt + black,
    inset: 0.6em,
    align: left + horizon,
    table.header([*Lệnh*], [*Cấp tương đương bên Typst*]),
    [`#chapter[...]`], [`=`],
    [`#section[...]`], [`==`],
    [`#subsection[...]`], [`===`],
    [`#subsubsection[...]`], [`====`],
    [`#paragraph[...]`], [`=====`],
    [`#subparagraph[...]`], [`======`],
  )
]

*Ví dụ minh hoạ:*

```typ
#chapter[Phương trình bậc nhất hai ẩn]
#section[Khái niệm phương trình bậc nhất hai ẩn]
#subsection[Lý thuyết]
#subsubsection[Phương trình bậc nhất hai ẩn]
```

#chapter[Tự tạo theorem]

#section[`#createTheoremEx` -- tạo một theorem mới]

#subsection[Lệnh khai báo đầy đủ]

Để tạo một `theorem` mới để có thể dùng các chức năng của `ex_test`, thầy cô dùng lệnh `#createTheoremEx` như sau:

```typ
#let <ten> = createTheoremEx(
  "<ten>",                // tên lệnh, đặt trong ""
  "<nhan>",               // nhãn hiển thị, đặt trong ""
  boxF: <ham-khung>,          // mặc định: không khung
  contentF: <ham-noidung>,    // mặc định: in đậm nhãn + nội dung
  imminiF: <ham-nhan-immini>, // nhãn dùng khi có #immini
  numbered: <true/false>,   // false = không đánh số
)
```

#subsection[Khai báo cơ bản]

*Ví dụ minh hoạ khai báo cơ bản:*
```typ
#let minhhoa = createTheoremEx(
  "minhhoa",
  "Minh hoạ",
)
```

*Ví dụ minh hoạ sử dụng:*
```typ
#minhhoa(tieude: "Tên minh hoạ")[
  Đây là phần minh hoạ của cách sử dụng.
]
```

*Kết quả trên PDF:*
#let minhhoa = createTheoremEx(
  "minhhoa",
  "Minh hoạ",
)
#minhhoa(tieude: "Tên minh hoạ")[
  Đây là phần minh hoạ của cách sử dụng.
]

#subsection[Bộ đếm số]
Khi sang Chương mới hoặc Bài mới, các bộ đếm `vd`, `bt`, `btrl`, `ex`... sẽ KHÔNG tự động reset về 0. Tuy nhiên gói lệnh `ex_test` đã tạo sẵn các counter. Nếu thầy cô muốn reset về 0 thì thầy cô phải chèn lệnh sau vào phần cấu hình heading:
```typ
#counter("<tên theorem>_count").update(0)
```

*Ví dụ minh hoạ:*
```typ
#counter("ex_count").update(0)
#counter("bt_count").update(0)
#counter("vd_count").update(0)
```

Thầy cô có thể tham khảo `show heading.where(level: 1)` trong `lib.typ`.

#subsection[`boxF` -- tạo khung]

Khai báo khung cho Minh hoạ:

```typ
#let minhhoaBoxF(body) = {         // tên tuỳ ý
  block(
    width: 100%,                  // bề ngang hiện đủ 100% trang giấy
    radius: 6pt,                  // độ bo tròn
    inset: 1em,                   // khoảng cách giữa viền và nội dung
    fill: blue.lighten(90%),      // màu nền
    stroke: 1pt + blue,           // độ dày và màu viền
    breakable: true,              // cho phép ngắt giữa trang
  )[#body]
}
```

Khi đó ta khai báo như sau:
```typ
#let minhhoa = createTheoremEx(
  "minhhoa",
  "Minh hoạ",
  boxF: minhhoaBoxF,
)
```

*Kết quả khi sử dụng:*

#let minhhoaBoxF(body) = {
  // tên tuỳ ý
  block(
    width: 100%, // bề ngang hiện đủ 100% trang giấy
    radius: 6pt, // độ bo tròn
    inset: 1em, // khoảng cách giữa viền và nội dung
    fill: blue.lighten(90%), // màu nền
    stroke: 1pt + blue, // độ dày và màu viền
    breakable: true, // cho phép ngắt giữa trang
  )[#body]
}
#let minhhoa = createTheoremEx(
  "minhhoa",
  "Minh hoạ",
  boxF: minhhoaBoxF,
)
#minhhoa(tieude: "Tên minh hoạ")[
  Đây là phần minh hoạ của cách sử dụng.
]

#subsection[`contentF` `imminiF` -- thay đổi cấu trúc của nội dung]

Đôi khi ta muốn đưa nguồn bài tập xuống cạnh dưới bên phải khung thay vì in đậm ở phần nhãn, ta cần khai báo lại `imminiF` và `contentF`, chẳng hạn sau đây là khai báo cho Minh hoạ:

#pagebreak()

```typ
#let minhhoaContentF(body, fulllabel: none, shortlabel: none, label: none, title: none, count: none) = [
  // In đậm Tiêu đề
  #strong[#shortlabel]
  // Xuất nội dung
  #body
  // Xuất nguồn đề bài in nghiêng
  #if title != none {
    [#parbreak()#h(1fr)#emph[Nguồn: #title]]
  }
]
```

```typ
#let minhhoaImminiF(fulllabel: none, shortlabel: none, label: none, title: none, count: none) = [
  #strong[#shortlabel]
]
```

Khi đó ta khai báo như sau:
```typ
#let minhhoa = createTheoremEx(
  "minhhoa",
  "Minh hoạ",
  boxF: minhhoaBoxF,
  contentF: minhhoaContentF,
  imminiF: minhhoaImminiF
)
```

*Kết quả khi sử dụng:*
#let minhhoaContentF(body, fulllabel: none, shortlabel: none, label: none, title: none, count: none) = [
  // In đậm Tiêu đề
  #strong[#shortlabel]
  // Xuất nội dung
  #body
  // Xuất nguồn đề bài in nghiêng
  #if title != none {
    [#parbreak()#h(1fr)#emph[Nguồn: #title]]
  }
]
#let minhhoaImminiF(fulllabel: none, shortlabel: none, label: none, title: none, count: none) = [
  #strong[#shortlabel]
]
#let minhhoa = createTheoremEx(
  "minhhoa",
  "Minh hoạ",
  boxF: minhhoaBoxF,
  contentF: minhhoaContentF,
  imminiF: minhhoaImminiF,
)

#minhhoa(tieude: "Tên minh hoạ")[
  Đây là phần minh hoạ của cách sử dụng.
]

*Lưu ý:* Để rõ hơn thầy cô xem ở cuối file `lib.typ`.

#section[`#immini` `#imminiL`  -- hình minh hoạ cho bài tập]

Dùng lệnh `#immini` để xếp đề bài bên trái, hình bên phải. Ngược lại, dùng `#imminiL` để xếp hình bên trái, đề bài bên phải.

*Ví dụ minh hoạ:*

```typ
#luuy[
  #immini[
    Toạ độ giao điểm của hai đường thẳng chính là nghiệm của hệ phương
    trình tương ứng.
  ][
    #image("../imgs/minh-hoa.png", width: 6cm)
  ]
]

#luuy[
  #imminiL[
    Toạ độ giao điểm của hai đường thẳng chính là nghiệm của hệ phương
    trình tương ứng.
  ][
    #image("../imgs/minh-hoa.png", width: 6cm)
  ]
]
```
*Kết quả:*

#luuy[
  #immini[
    Toạ độ giao điểm của hai đường thẳng chính là nghiệm của hệ phương
    trình tương ứng.
  ][
    #rect(width: 6cm, height: 3.2cm, stroke: 1pt + black, radius: 4pt)[
      #align(center + horizon)[_(hình minh hoạ ở đây)_]
    ]
  ]
]

#luuy[
  #imminiL[
    Toạ độ giao điểm của hai đường thẳng chính là nghiệm của hệ phương
    trình tương ứng.
  ][
    #rect(width: 6cm, height: 3.2cm, stroke: 1pt + black, radius: 4pt)[
      #align(center + horizon)[_(hình minh hoạ ở đây)_]
    ]
  ]
]

#section[`#loigiai` -- lời giải]

`#loigiai[...]` đặt bên trong một theorem (`vd`, `bt`, `btrl`, `ex`, `chc`,...) để chứa lời giải. Lệnh này *tự động* kiểm tra cấu hình `#state("<ten>_show_ans")` để quyết định hiển thị lời giải hay thay bằng dòng kẻ chấm (nếu đã dùng `#dotlinefull`).

`#dotlineEX(n)`: in ra trực tiếp `n` dòng kẻ chấm (dùng ngay trong `#loigiai`).

`#dotlinefull("bt", socot: 2)`: đặt ở đầu file, khiến *mọi* `#loigiai` của `bt` tự động thay bằng dòng kẻ chấm với số dòng được tính tự động theo độ dài lời giải gốc, chia thành `socot` cột.

*Ví dụ minh hoạ 1:*

```typ
#bt[
  Đề bài...
  #loigiai[
    Hướng dẫn giải...
  ]
]
```

*Kết quả:*

#bt[
  Đề bài...
  #loigiai[
    Hướng dẫn giải...
  ]
]

*Ví dụ minh hoạ 2:*

```typ
#dotlineEX(5, socot: 2)
```

*Kết quả:*

#dotlineEX(5, socot: 2)

#pagebreak()

*Lưu ý:* Để đổi tiêu đề của `#loigiai`, thầy cô khai báo:

```typ
#loigiaiEX.update([*Hướng dẫn giải.*])
```

#section[`#chc` -- câu hỏi con]

Đối với các dạng đề như thi Đánh giá năng lực, thường sẽ gặp trường hợp có nhiều câu hỏi dùng chung giả thiết. Khi đó ta dùng `#chc` ngay sau `theorem` chứa giả thiết chung.

#subsection[Cú pháp]

```typ
#<tên theorem>(sochc: <số câu hỏi con>)[
  Giả thiết chung (ngữ cảnh)...
]

#chc(tieude: <nguồn riêng câu này, có thể bỏ trống>)[
  Nội dung câu hỏi con thứ nhất...
  #loigiai[Lời giải riêng của câu này...]
]

#chc[
  Nội dung câu hỏi con thứ hai...
]
```

- `sochc: n` khai báo trên `theorem`: cho biết có `n` câu hỏi con bên trong. Khi đó, thay vì hiển thị "Câu 5", tiêu đề `theorem` sẽ tự đổi thành dạng *Dựa vào thông tin dưới đây để trả lời các câu từ $X$ đến $X + n$*. Trong đó, $X$ là đánh số hiện tại của `theorem`.

- Nếu KHÔNG khai báo `sochc:` (hoặc để `sochc: 0`), các `#chc` bên trong sẽ tự đánh số kiểu "$X$.a", "$X$.b".... Nếu `theorem` không đánh số thì sẽ hiện "a", "b", "c"...

- Mỗi `#chc[...]` có thể được sử dụng độc lập với `theorem`, copy tất cả cấu hình áp dụng cho `theorem`, có thể dùng `#loigiai[...]` riêng và `title:` (nguồn) riêng cho từng câu con...

#pagebreak()

#subsection[Ví dụ minh hoạ]

```typ
#minhhoa(sochc: 2)[
  Cho hai đường thẳng $d_1: y = x + 1$ và $d_2: y = -x + 3$.
]

#chc[
  Tìm giao điểm của $d_1$ và $d_2$.
  #loigiai[
    Giải hệ $heva(y = x + 1, y = -x + 3)$ được $x = 1$, $y = 2$.
  ]
]
#chc[
  Vẽ hai đường thẳng trên cùng một hệ trục toạ độ.
  #loigiai[
    Học sinh tự vẽ dựa theo 2 điểm đặc biệt của mỗi đường thẳng.
  ]
]

#minhhoa[
  Cho hai đường thẳng $d_1: y = x + 1$ và $d_2: y = -x + 3$.
]

#chc[
  Tìm giao điểm của $d_1$ và $d_2$.
  #loigiai[
    Giải hệ $heva(y = x + 1, y = -x + 3)$ được $x = 1$, $y = 2$.
  ]
]
#chc[
  Vẽ hai đường thẳng trên cùng một hệ trục toạ độ.
  #loigiai[
    Học sinh tự vẽ dựa theo 2 điểm đặc biệt của mỗi đường thẳng.
  ]
]
```

*Kết quả:*

#minhhoa(sochc: 2)[
  Cho hai đường thẳng $d_1: y = x + 1$ và $d_2: y = -x + 3$.
]

#chc[
  Tìm giao điểm của $d_1$ và $d_2$.
  #loigiai[
    Giải hệ hai phương trình trên, ta được $x = 1$, $y = 2$.
  ]
]
#chc[
  Vẽ hai đường thẳng trên cùng một hệ trục toạ độ.
  #loigiai[
    Học sinh tự vẽ dựa theo 2 điểm đặc biệt của mỗi đường thẳng.
  ]
]

#minhhoa[
  Cho hai đường thẳng $d_1: y = x + 1$ và $d_2: y = -x + 3$.
]

#chc[
  Tìm giao điểm của $d_1$ và $d_2$.
  #loigiai[
    Giải hệ $heva(y = x + 1, y = -x + 3)$ được $x = 1$, $y = 2$.
  ]
]
#chc[
  Vẽ hai đường thẳng trên cùng một hệ trục toạ độ.
  #loigiai[
    Học sinh tự vẽ dựa theo 2 điểm đặc biệt của mỗi đường thẳng.
  ]
]

#subsection[Đổi chữ "Dựa vào thông tin dưới đây..."]

Câu dẫn mặc định trước nhóm câu hỏi con lấy từ 2 biến `fromchc` và `tochc`:

```typ
#fromchc.update("Dựa vào thông tin dưới đây để trả lời các câu từ")
#tochc.update("đến")
```

Đặt lệnh này ở `main.typ` (trước phần nội dung) nếu muốn đổi sang cách diễn
đạt khác, ví dụ rút gọn hoặc dùng cho đề thi kiểu khác.

= Trắc nghiệm và tự luận

== `#choice` -- trắc nghiệm 4 phương án

- Tham số `socot`: ép số cột hiển thị 4 phương án (1, 2 hoặc 4). Nếu bỏ trống,
  package tự tính cột tối ưu theo độ rộng nội dung.
- `dapan: "B"`: khai báo nếu muốn xuất bảng đáp án tự động bằng `#XuatDapAn`
  (xem bên dưới).
- Nếu muốn thay các chữ cái A, B, C, D, thành số 1, 2, 3, 4 thì dùng `#choiceN`.
- Nếu chỉ truyền 1 phương án, `#choice` sẽ vẽ dạng `underbracket` đánh số
  A, B, C... tăng dần theo thứ tự xuất hiện (dùng cho trắc nghiệm tìm lỗi sai của môn Anh ngữ).
- `khoangcach: 1em`: chỉnh khoảng cách giữa các dòng phương án khi các đáp án xếp thành nhiều dòng.
  Tham số này cũng có ở `#choiceN` và `#choiceTF`.
- Cuối mỗi phương án (`choice`/`choiceN`/`choiceTF`) đều tự in thêm ký tự lấy
  từ biến `dotEX` (mặc định là dấu `.`). Muốn đổi (ví dụ bỏ hẳn dấu chấm),
  đặt ở `main.typ`: `#dotEX.update([])`.

*Ví dụ minh hoạ 1:*

```typ
#ex[
  Phương trình nào sau đây KHÔNG là phương trình bậc nhất hai ẩn?
  #choice(
    [$x - 2y = 5$],
    [$0x + 0y = -3$],
    [$6x + 0y = 1$],
    [$0x - 4y = 3$],
    socot: 4,
    dapan: "B",
  )
  #loigiai[
    Đáp án B vì $a = b = 0$.
  ]
]
```

*Kết quả:*

#BatDauLuuDapAn("demo-tracnghiem")
#ex[
  Phương trình nào sau đây KHÔNG là phương trình bậc nhất hai ẩn?
  #choice(
    [$x - 2y = 5$],
    [$0x + 0y = -3$],
    [$6x + 0y = 1$],
    [$0x - 4y = 3$],
    dapan: "B",
  )
  #loigiai[
    Đáp án B vì $a = b = 0$.
  ]
]

*Ví dụ minh hoạ 2:*

```typ
#ex[
  Yoghurt, #choice[one of] the #choice[healthiest] snacks, #choice(dapan: "B")[are] adviced for people with #choice[daily] calcium needs.
]
```

*Kết quả:*

#ex[
  Yoghurt, #choice[one of] the #choice[healthiest] snacks, #choice(dapan: "B")[are] adviced for people with #choice[daily] calcium needs.
]

#section[`#choiceTF` -- trắc nghiệm Đúng/Sai]

- Mặc định sẽ không kẻ bảng, thêm tham số `kieu: "t"` để kẻ bảng.
- Khi không có tham số `kieu: "t"` sẽ in dạng danh sách chia cột như `#choice`. Nếu muốn chỉnh số cột thì thêm tham số `socot: 2`.
- Lệnh `#itemchoice` cũng có thể thêm tham số `socot: 2`.
- Lệnh `#itemchoice` tự động đọc tham số `dapan` đã khai báo ở `#choiceTF` cùng câu để in đậm sẵn nhãn "a) Đúng", "b) Sai"... ở đầu mỗi ý. Vì vậy nội dung từng dòng bên trong `#itemchoice[...]` chỉ nên đưa ra các bước giải, KHÔNG cần gõ lại chữ "Đúng"/"Sai" — nếu gõ lại sẽ bị lặp

#v(2em)

*Ví dụ minh hoạ 1:*

```typ
#ex[
  Phát biểu nào sau đây đúng/sai?
  #choiceTF(
    [Phương trình $x + y = 1$ là bậc nhất hai ẩn],
    [Phương trình $0x + 0y = 1$ là bậc nhất hai ẩn],
    [Phương trình $x + 0y = 1$ là bậc nhất hai ẩn],
    [Phương trình $0x + y = 0$ là bậc nhất hai ẩn],
    dapan: "Đ, S, Đ, Đ",
    socot: 2
  )
  #loigiai[
    #itemchoice[
      + Vì thoả $a != 0$.
      + Vì $a = b = 0$.
      + Vì thoả $a != 0$.
      + Vì thoả $b != 0$.
    ]
  ]
]
```

*Kết quả:*

#ex[
  Phát biểu nào sau đây đúng/sai?
  #choiceTF(
    [Phương trình $x + y = 1$ là bậc nhất hai ẩn],
    [Phương trình $0x + 0y = 1$ là bậc nhất hai ẩn],
    [Phương trình $x + 0y = 1$ là bậc nhất hai ẩn],
    [Phương trình $0x + y = 0$ là bậc nhất hai ẩn],
    dapan: "Đ, S, Đ, Đ",
    socot: 2,
  )
  #loigiai[
    #itemchoice[
      + Vì thoả $a != 0$.
      + Vì $a = b = 0$.
      + Vì thoả $a != 0$.
      + Vì thoả $b != 0$.
    ]
  ]
]

*Ví dụ minh hoạ 2:*

```typ
#ex[
  Phát biểu nào sau đây đúng/sai?
  #choiceTF(
    [Phương trình $x + y = 1$ là bậc nhất hai ẩn],
    [Phương trình $0x + 0y = 1$ là bậc nhất hai ẩn],
    [Phương trình $x + 0y = 1$ là bậc nhất hai ẩn],
    [Phương trình $0x + y = 0$ là bậc nhất hai ẩn],
    dapan: "Đ, S, Đ, Đ",
    kieu: "t",
  )
  #loigiai[
    #itemchoice(socot: 2)[
      + Vì thoả $a != 0$.
      + Vì $a = b = 0$.
      + Vì thoả $a != 0$.
      + Vì thoả $b != 0$.
    ]
  ]
]
```

*Kết quả:*

#ex[
  Phát biểu nào sau đây đúng/sai?
  #choiceTF(
    [Phương trình $x + y = 1$ là bậc nhất hai ẩn],
    [Phương trình $0x + 0y = 1$ là bậc nhất hai ẩn],
    [Phương trình $x + 0y = 1$ là bậc nhất hai ẩn],
    [Phương trình $0x + y = 0$ là bậc nhất hai ẩn],
    dapan: "Đ, S, Đ, Đ",
    kieu: "t",
  )
  #loigiai[
    #itemchoice(socot: 2)[
      + Vì thoả $a != 0$.
      + Vì $a = b = 0$.
      + Vì thoả $a != 0$.
      + Vì thoả $b != 0$.
    ]
  ]
]

#section[`#shortans` -- câu trả lời ngắn]

Sử dụng tham số `kieu` để thay đổi kiểu in kết quả:
- `"..."`: hiện 1 dòng chấm ngắn (mặc định).
- `"oly"`: hiện 4 ô vuông.
- `"3"` một ô chữ nhật dài 3cm.

*Lưu ý:* `#shortans` cũng tự lưu đáp án vào hệ thống giống `#choice`. chỉ cần đặt bên trong cặp `#BatDauLuuDapAn` và `#KetThucLuuDapAn` là `#XuatDapAn` sẽ tự liệt kê luôn đáp án của các câu `#shortans`, không cần làm gì thêm.

*Ví dụ minh hoạ:*

```typ
#ex[
  Tổng hai nghiệm của phương trình... bằng bao nhiêu?
  #shortans("1234", kieu: "...")
]
#ex[
  Tổng hai nghiệm của phương trình... bằng bao nhiêu?
  #shortans("1234", kieu: "oly")
]
#ex[
  Tổng hai nghiệm của phương trình... bằng bao nhiêu?
  #shortans("1234", kieu: "3")
]
```

*Kết quả:*

#ex[
  Tổng hai nghiệm của phương trình... bằng bao nhiêu?
  #shortans("1234", kieu: "...")
]

#ex[
  Tổng hai nghiệm của phương trình... bằng bao nhiêu?
  #shortans("1234", kieu: "oly")
]

#ex[
  Tổng hai nghiệm của phương trình... bằng bao nhiêu?
  #shortans("1234", kieu: "3")
]

#section[`#BatDauLuuDapAn` `#KetThucLuuDapAn` `#XuatDapAn` #linebreak()-- lưu và xuất bảng đáp án tự động]

*Cách dùng:*

```typ
#BatDauLuuDapAn("<tên bản sao lưu>")
#KetThucLuuDapAn("<tên bản sao lưu>")
#XuatDapAn(
  "<tên bản sao lưu>",
  socot: <số cột>,
  duongthang: <độ rộng đường thẳng> + <màu sắc>,
  botron: <độ bo tròn>,
  khoangcach: <khoảng cách giữa các ô>,
  maunen: <màu nền của ô>,
)
```

*Ví dụ minh hoạ:*
```typ
#BatDauLuuDapAn("9D1-1-Tracnghiem")
#ex[ ... #choice(..., dapan: "B") ... ]
#ex[ ... #choice(..., dapan: "B") ... ]
#counter("ex_count").update(0) // reset bộ đếm
#ex[ ... #choiceTF(..., dapan: "Đ, S, Đ, Đ") ... ]
...
#KetThucLuuDapAn("9D1-1-Tracnghiem")

#XuatDapAn(
  "9D1-1-Tracnghiem",
  socot: 6,
  duongthang: 1pt + blue,
  maunen: blue.lighten(95%)
)
```

#KetThucLuuDapAn("demo-tracnghiem")

*Kết quả:*

#XuatDapAn("demo-tracnghiem", socot: 6, duongthang: 1pt + blue, maunen: blue.lighten(95%))

*Lưu ý:* Nếu có reset bộ đếm giữa chừng thì vẫn lưu đáp án theo đánh số của đề bài.

#section[`#dapso` -- đáp số vắn tắt cho bài toán tự luận]

*Ví dụ minh hoạ:*

```typ
#bt[
  Giải phương trình $2x = 6$.
  #dapso($x = 3$, hien: true)
  #loigiai[Hướng dẫn giải...]
]
```

*Kết quả: *

#bt[
  Giải phương trình $2x = 6$.
  #loigiai[Hướng dẫn giải...]
  #dapso($x = 3$, hien: true)
]

*Lưu ý:*
- Lệnh này sẽ KHÔNG lưu lại kết quả bằng `#BatDauLuuDapAn` và `#KetThucLuuDapAn`.
- Có 2 cách bật/tắt hiển thị đáp số cho *toàn bộ* tài liệu kể từ vị trí đặt lệnh:
  - Gọi thẳng state: `#dapso_show_state.update(true)` / `update(false)`.
  - Hoặc dùng lệnh tắt có sẵn: `#showdapso` để hiện và `#hidedapso` (hoặc
    `#exitdapso`) để ẩn.
- Tham số `hien:` truyền trực tiếp trong `#dapso(...)` luôn được ưu tiên xử lý hơn cấu hình chung bằng các cách trên.

#section[`#listEX` `#itemize` `#enumerate`  -- tạo danh sách]

#subsection[`#listEX` -- tự động sắp xếp]

Lệnh `#listEX` dùng để lập danh sách thay cho `enum`, trong đó các ý của bài tập sẽ tự động dàn cột tương tự bên LaTeX (tối đa 4 cột). Nếu muốn chỉ định số cột cụ thể thì ta thêm tham số `socot`. Cú pháp lệnh đầy đủ như sau:

```typ
#listEX(socot: <số cột>)[
  + Ý thứ nhất;
  + Ý thứ hai;
  + Ý thứ ba.
]
```

*Lưu ý:* Nếu số lượng ý nhỏ từ 26 ý trở xuống thì vẫn đánh bằng chữ cái. Ngược lại, nếu trên 26 thì sẽ chuyển sang đánh bằng số.

*Ví dụ minh hoạ:*

```typ
#listEX[
  + $x + 2y = 3$;
  + $0x + y = -2$;
  + $x + 0y = 3$.
]
```

*Kết quả:*

#listEX(socot: 3)[
  + $x + 2y = 3$;
  + $0x + y = -2$;
  + $x + 0y = 3$.
]

#subsection()[`#itemize` `#enumerate` -- thay thế cho LaTeX]

Hai lệnh này chỉ là bọc lại `list`/`enum` gốc của Typst với khoảng cách trên/dưới
và kiểu đánh số quen thuộc bên LaTeX, cú pháp bên trong dùng `-`/`+` như bình
thường của Typst:

```typ
#itemize[
  - Ý gạch đầu dòng thứ nhất
  - Ý gạch đầu dòng thứ hai
]
```

```typ
#enumerate[
  + Ý đánh số thứ nhất
  + Ý đánh số thứ hai
]
```

*Kết quả:*

#itemize[
  - Ý gạch đầu dòng thứ nhất
  - Ý gạch đầu dòng thứ hai
]

#enumerate[
  + Ý đánh số thứ nhất
  + Ý đánh số thứ hai
]

*Khác biệt với `#listEX`:* hai lệnh `#itemize` và `#enumerate` không tự chia cột, chỉ đổi
kiểu marker/đánh số và thêm khoảng cách khối. Khi cần danh sách các ý của một câu hỏi (tự chia cột theo bề rộng trang), dùng `#listEX`.
