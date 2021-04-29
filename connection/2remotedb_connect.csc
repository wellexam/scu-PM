import csdbc_mysql
import regex
import codec.json as json
import db
function Remotedb_connect_str(connect)
    var correct = true
    var ifs = iostream.ifstream(connect)
    var cfg = json.to_var(json.from_stream(ifs))
    if cfg.exist("server") && cfg.exist("port") && cfg.exist("password") && cfg.exist("user")
        # 正常执行数据库
        var cnt_str = "Driver={MariaDB ODBC 3.0 Driver};Server=" + cfg.server+ ";Port=" + cfg.port + ";Database=scupm;User="+cfg.user+";Password="+cfg.password+";Option=3";
        try
            db.csdbc_adpter = csdbc_mysql.connect_str(cnt_str)
        catch e
            # system.out.println(e.what)
            # 检查访问错误
            var reg=regex.build("Access denied")
            var res = reg.search(e.what)
            if !res.empty()
                system.out.println("【ERROR】访问权限错误，请检查账户或密码")
            end
            reg = regex.build("HY00")
            res = reg.search(e.what)
            if !res.empty()
                system.out.println("【ERROR】访问超时！请检查目标服务器地址或服务器运行情况！")
            end
        end
        db.start()
    else
        system.out.print("数据读取异常，请检查工作路径是否正确，以及路径下是否有./login_config.json文件，以及该文件是否配置正确,四个字段为：\n\"server\":\n\"port\":\n\"user\":\n\"password\":")
    end
end
Remotedb_connect_str("./login_config.json")
# db.csdbc_adpter = csdbc_mysql.connect("./db_config.json")