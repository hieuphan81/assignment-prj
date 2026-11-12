package vn.math10ai.content;

import java.util.List;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class ContentRepository {
    private final JdbcTemplate jdbc;

    public ContentRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<TopicDto> findActiveTopics() {
        return jdbc.query("""
                SELECT topic_id, topic_name, description, topic_order
                FROM dbo.TOPICS WHERE status = 'ACTIVE' ORDER BY topic_order
                """, (rs, row) -> new TopicDto(rs.getInt("topic_id"), rs.getString("topic_name"),
                rs.getString("description"), rs.getInt("topic_order")));
    }

    public List<LessonDto> findPublishedLessons(Integer topicId) {
        String sql = """
                SELECT l.lesson_id, l.topic_id, l.title, l.description, l.content, l.video_url, l.resource_url, l.order_index
                FROM dbo.LESSONS l JOIN dbo.TOPICS t ON t.topic_id=l.topic_id WHERE l.status = 'PUBLISHED' AND t.status='ACTIVE'
                """ + (topicId == null ? "" : " AND l.topic_id = ?") + " ORDER BY l.topic_id, l.order_index, l.lesson_id";
        var mapper = (org.springframework.jdbc.core.RowMapper<LessonDto>) (rs, row) -> new LessonDto(
                rs.getInt("lesson_id"), rs.getInt("topic_id"), rs.getString("title"),
                rs.getString("description"), rs.getString("content"), rs.getString("video_url"),
                rs.getString("resource_url"), rs.getInt("order_index"));
        return topicId == null ? jdbc.query(sql, mapper) : jdbc.query(sql, mapper, topicId);
    }

    public List<TopicDto> findManagedTopics(Integer creatorId, boolean admin) {
        String sql="SELECT topic_id,topic_name,description,topic_order FROM dbo.TOPICS"+(admin?"":" WHERE created_by=?")+" ORDER BY topic_order";
        return admin?jdbc.query(sql,(rs,row)->new TopicDto(rs.getInt(1),rs.getString(2),rs.getString(3),rs.getInt(4))):
                jdbc.query(sql,(rs,row)->new TopicDto(rs.getInt(1),rs.getString(2),rs.getString(3),rs.getInt(4)),creatorId);
    }
    public List<LessonDto> findManagedLessons(Integer ownerId, boolean admin) {
        String sql="SELECT lesson_id,topic_id,title,description,content,video_url,resource_url,order_index FROM dbo.LESSONS"+(admin?"":" WHERE teacher_id=?")+" ORDER BY topic_id,order_index";
        var mapper=(org.springframework.jdbc.core.RowMapper<LessonDto>)(rs,row)->new LessonDto(rs.getInt(1),rs.getInt(2),rs.getString(3),rs.getString(4),rs.getString(5),rs.getString(6),rs.getString(7),rs.getInt(8));
        return admin?jdbc.query(sql,mapper):jdbc.query(sql,mapper,ownerId);
    }
    public int insertTopic(int owner,TopicRequest r){return jdbc.queryForObject("INSERT dbo.TOPICS(created_by,topic_name,description,topic_order,status) OUTPUT INSERTED.topic_id VALUES(?,?,?,?,?)",Integer.class,owner,r.name().trim(),r.description(),r.order(),r.status()==null?"ACTIVE":r.status());}
    public int updateTopic(int id,int owner,boolean admin,TopicRequest r){String sql="UPDATE dbo.TOPICS SET topic_name=?,description=?,topic_order=?,status=? WHERE topic_id=?"+(admin?"":" AND created_by=?");return admin?jdbc.update(sql,r.name().trim(),r.description(),r.order(),r.status()==null?"ACTIVE":r.status(),id):jdbc.update(sql,r.name().trim(),r.description(),r.order(),r.status()==null?"ACTIVE":r.status(),id,owner);}
    public int insertLesson(int owner,LessonRequest r){return jdbc.queryForObject("INSERT dbo.LESSONS(topic_id,teacher_id,title,description,content,video_url,resource_url,order_index,status) OUTPUT INSERTED.lesson_id VALUES(?,?,?,?,?,?,?,?,?)",Integer.class,r.topicId(),owner,r.title().trim(),r.description(),r.content(),r.videoUrl(),r.resourceUrl(),r.order(),r.status()==null?"DRAFT":r.status());}
    public int updateLesson(int id,int owner,boolean admin,LessonRequest r){String sql="UPDATE dbo.LESSONS SET topic_id=?,title=?,description=?,content=?,video_url=?,resource_url=?,order_index=?,status=? WHERE lesson_id=?"+(admin?"":" AND teacher_id=?");return admin?jdbc.update(sql,r.topicId(),r.title().trim(),r.description(),r.content(),r.videoUrl(),r.resourceUrl(),r.order(),r.status()==null?"DRAFT":r.status(),id):jdbc.update(sql,r.topicId(),r.title().trim(),r.description(),r.content(),r.videoUrl(),r.resourceUrl(),r.order(),r.status()==null?"DRAFT":r.status(),id,owner);}
    public int updateLessonVideoUrl(int id, String videoUrl) {
        return jdbc.update("UPDATE dbo.LESSONS SET video_url = ? WHERE lesson_id = ?", videoUrl, id);
    }
    public boolean topicExists(int topicId){return Boolean.TRUE.equals(jdbc.query("SELECT CAST(CASE WHEN EXISTS(SELECT 1 FROM dbo.TOPICS WHERE topic_id=? AND status='ACTIVE') THEN 1 ELSE 0 END AS BIT)",rs->rs.next()&&rs.getBoolean(1),topicId));}
    public boolean ownsTopic(int topicId,int owner,boolean admin){return Boolean.TRUE.equals(jdbc.query("SELECT CAST(CASE WHEN EXISTS(SELECT 1 FROM dbo.TOPICS WHERE topic_id=? AND status='ACTIVE') THEN 1 ELSE 0 END AS BIT)",rs->rs.next()&&rs.getBoolean(1),topicId));}
}
